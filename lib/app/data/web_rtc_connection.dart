import 'dart:async';
import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebRTCConnection {
  final String signalingServerIPAddress;
  final String signalingServerPort;
  late final Stream<WebRTCConnectionEvent> events;
  late final MediaStream _localStream;
  late final RTCPeerConnection _peerConnection;
  late final WebSocketChannel _webSocketChannel;
  late final StreamController<WebRTCConnectionEvent> _eventStreamController;
  late final RTCVideoRenderer _localRenderer;

  WebRTCConnection({
    required this.signalingServerIPAddress,
    required this.signalingServerPort,
  });

  Future<void> start() async {
    _localRenderer = RTCVideoRenderer();
    _localRenderer.initialize();
    await _initCameraAndMic();
    await _establishWebSocketConnection();
    await _createPeerConnection();
    _eventStreamController = StreamController();
    events = _eventStreamController.stream;
  }

  RTCVideoRenderer get localRenderer => _localRenderer;

  /// provides the signaling server address without a protocol
  String _signalingServerAddress() {
    return "$signalingServerIPAddress:$signalingServerPort";
  }

  Future<void> terminate() async {
    _localStream.getTracks().forEach((track) async {
      await track.stop();
    });

    await _peerConnection.close();

    _localRenderer.dispose();
    _localRenderer.dispose();
    _webSocketChannel.sink.close();
    _localStream.dispose();
    _peerConnection.dispose();
    _eventStreamController.close();
  }

  _establishWebSocketConnection() {
    final Uri uri = Uri.parse("ws://${_signalingServerAddress()}/ws");
    _webSocketChannel = WebSocketChannel.connect(uri);
    _webSocketChannel.stream.listen(_handleIncomingMessagesFromSignalingServer);
  }

  Future<void> _initCameraAndMic() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        // switch between user (front) and environment (back) camera
        'facingMode': 'user',

        // resolution settings
        'width': {
          'min': 1920,
          'ideal': 3648,
          'max': 3648,
        },
        'height': {
          'min': 824,
          'ideal': 2736,
          'max': 2736,
        },
        'frameRate': {
          'min': 15,
          'ideal': 30,
          'max': 30,
        },
      }
    };

    try {
      _localStream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _localRenderer.srcObject = _localStream;
    } catch (e) {
      throw "Error initializing camera and mic: $e";
    }
  }

  Future<void> _createPeerConnection() async {
    final Map<String, dynamic> config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    };

    _peerConnection = await createPeerConnection(config);
    _localStream.getTracks().forEach((track) {
      _peerConnection.addTrack(track, _localStream);
    });

    _peerConnection.onIceCandidate = (candidate) {
      _sendIceCandidateToSignalServer(candidate);
    };

    _peerConnection.onTrack = (event) {
      // not expecting any valid track from peer
    };

    final offer = await _createOffer();
    await _peerConnection.setLocalDescription(offer);
    await _sendOfferToSignalServer(offer);
  }

  Future<RTCSessionDescription> _createOffer() async {
    final Map<String, dynamic> offerSDPConstraints = {
      'mandatory': {'OfferToReceiveAudio': true, 'OfferToReceiveVideo': true},
      'optional': []
    };
    return await _peerConnection.createOffer(offerSDPConstraints);
  }

  Future<void> switchCamera() async {
    for (var track in _localStream.getVideoTracks()) {
      await Helper.switchCamera(track);
    }
  }

  Future<void> _sendOfferToSignalServer(RTCSessionDescription offer) async {
    final data = jsonEncode(SignalServerMessage.offerMessage(offer));
    _webSocketChannel.sink.add(data);
  }

  Future<void> _sendIceCandidateToSignalServer(
      RTCIceCandidate candidate) async {
    final data = jsonEncode(SignalServerMessage.iceCandidateMessage(candidate));
    _webSocketChannel.sink.add(data);
  }

  _handleIncomingMessagesFromSignalingServer(dynamic message) async {
    final Map<String, dynamic> data = jsonDecode(message);

    switch (data['type']) {
      case 'candidate':
        await _addRemoteIceCandidateToConnection(data['candidate']);
        break;
      case 'answer':
        _addAnswerToConnection(data['sdp']);
        break;
      case 'bye':
        _sendEventMessageToUI(const WebRTCConnectionEvent(
            type: WebRTCConnectionEventType.remotePeerTerminatedConnection));
        break;
      case 'error':
        _handleErrorMessagesFromRemotePeer(data['message']);
        break;
      case 'renegotiate':
        await _renegotiateConnection();
        break;
      default:
        _handleCustomControlMessage(data);
    }
  }

  _handleCustomControlMessage(Map<String, dynamic> data) {
    WebRTCConnectionEventType? type;
    dynamic additionalData;
    switch (data['type']) {
      case 'mute':
        type = WebRTCConnectionEventType.muteAudio;
        additionalData = data;
        break;
      case 'unmute':
        type = WebRTCConnectionEventType.unmuteAudio;
        additionalData = data;
        break;
      case 'pause':
        type = WebRTCConnectionEventType.pauseMediaFeed;
        additionalData = data;
        break;
      case 'resume':
        type = WebRTCConnectionEventType.pauseMediaFeed;
        additionalData = data;
        break;
      default:
        type = WebRTCConnectionEventType.unknown;
        additionalData = data;
        break;
    }
    _eventStreamController
        .add(WebRTCConnectionEvent(type: type, additionalData: additionalData));
  }

  Future<void> _renegotiateConnection() async {
    final offer = await _createOffer();
    await _peerConnection.setLocalDescription(offer);
    await _sendOfferToSignalServer(offer);
  }

  /// [errorData] is expected to be of the form
  /// {"type": "error", "message": "put error message here"}
  _handleErrorMessagesFromRemotePeer(Map<String, dynamic> errorData) {
    _eventStreamController.add(WebRTCConnectionEvent(
        type: WebRTCConnectionEventType.error,
        additionalData: errorData['message']));
  }

  Future<void> _addAnswerToConnection(Map<String, dynamic> answerData) async {
    final RTCSessionDescription answer = RTCSessionDescription(
      answerData['sdp'],
      answerData['type'],
    );

    await _peerConnection.setRemoteDescription(answer);
  }

  Future<void> _addRemoteIceCandidateToConnection(
      Map<String, dynamic> candidateData) async {
    final RTCIceCandidate candidate = RTCIceCandidate(
        candidateData['candidate'],
        candidateData['sdpMid'],
        candidateData['sdpMLineIndex']);

    await _peerConnection.addCandidate(candidate);
  }

  _sendEventMessageToUI(WebRTCConnectionEvent event) {
    _eventStreamController.add(event);
  }
}

/// a list of events to inform the ui about changes to internal state of [WebRTCConnection]
enum WebRTCConnectionEventType {
  remotePeerTerminatedConnection,
  changeCamera,
  error,
  muteAudio,
  unmuteAudio,
  pauseMediaFeed,
  resumeMediaFeed,
  unknown
}

class WebRTCConnectionEvent {
  final WebRTCConnectionEventType type;
  final dynamic additionalData;

  const WebRTCConnectionEvent({
    required this.type,
    this.additionalData,
  });
}

enum WebRTCConnectionState {
  connected,
  disconnecting,
  connecting,
  disconnected
}

abstract class SignalServerMessage {
  static Map<String, dynamic> offerMessage(RTCSessionDescription offer) {
    return {"type": "offer", "sdp": offer.toMap()};
  }

  static Map<String, dynamic> iceCandidateMessage(RTCIceCandidate candidate) {
    return {"type": "candidate", "candidate": candidate.toMap()};
  }
}
