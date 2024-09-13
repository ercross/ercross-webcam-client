import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;

class WebRTCConnection {
  late RTCPeerConnection _peerConnection;
  late MediaStream _localStream;
  final RTCVideoRenderer localRenderer;
  final String pcIpAddress;
  final String pcPort;

  WebRTCConnection(this.localRenderer,
      {required this.pcIpAddress, required this.pcPort});

  Future<void> initWebRTC() async {
    _localStream = await _getUserMedia();
    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    });

    _localStream.getTracks().forEach((track) {
      _peerConnection.addTrack(track, _localStream);
    });

    _peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      _sendIceCandidateToSignalServer(candidate);
    };

    _peerConnection.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video') {
        localRenderer.srcObject = event.streams[0];
      }
    };

    RTCSessionDescription offer = await _peerConnection.createOffer();
    await _peerConnection.setLocalDescription(offer);

    await _sendOfferToSignalServer(offer);
  }

  Future<MediaStream> _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {'facingMode': "user"}
    };

    return await navigator.mediaDevices.getUserMedia(mediaConstraints);
  }

  Future<void> _sendOfferToSignalServer(RTCSessionDescription offer) async {
    final String url = 'http://$pcIpAddress:$pcPort/offer';
    await http.post(Uri.parse(url),
        body: jsonEncode({'sdp': offer.sdp, 'type': offer.type}),
        headers: {'Content-Type': 'application/json'});
  }

  Future<void> _sendIceCandidateToSignalServer(
      RTCIceCandidate candidate) async {
    final String url = 'http://$pcIpAddress:$pcPort/candidate';
    await http.post(Uri.parse(url),
        body: jsonEncode({
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex
        }),
        headers: {'Content-Type': 'application/json'});
  }

  Future<void> terminateConnection() async {
    _localStream.getTracks().forEach((track) async {
      await track.stop();
    });

    await _peerConnection.close();

    localRenderer.dispose();
  }
}
