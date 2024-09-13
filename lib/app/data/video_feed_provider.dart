import 'package:camera/camera.dart';
import 'package:ercross/app/data/web_rtc_connection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

enum VideoFeedConnectionState { connected, disconnecting, connecting, disconnected }

class VideoFeedProvider {
  late final RTCVideoRenderer renderer;
  late final CameraController cameraController;
  late final WebRTCConnection webRTCConnection;

  final String signalServerIpAddress;
  final String signalServerPort;

  VideoFeedProvider({
    required this.signalServerIpAddress,
    required this.signalServerPort,
  });

  /// [start] can throw exception
  Future<void> start() async {
    renderer = RTCVideoRenderer();
    renderer.initialize();
    await _initializeCamera();
    await _startStreaming(ipAddress: signalServerIpAddress, port: signalServerPort);
  }

  /// [stop] must be called to dispose resources
  stop() {
    cameraController.dispose();
    webRTCConnection.terminateConnection();
    webRTCConnection.localRenderer.dispose();
  }

  _initializeCamera() async {
    final cameras = await availableCameras();
    final CameraDescription frontCamera = cameras.firstWhere((description) =>
        description.lensDirection == CameraLensDirection.front);
    cameraController = CameraController(frontCamera, ResolutionPreset.max);
    await cameraController.initialize();
  }

  _startStreaming({required String ipAddress, required String port}) async {
    webRTCConnection =
        WebRTCConnection(renderer, pcIpAddress: ipAddress, pcPort: port);
    await webRTCConnection.initWebRTC();
    cameraController.startImageStream((CameraImage image) {
      
      // The camera stream can be used to get the frames for further processing if needed
    });
  }
}
