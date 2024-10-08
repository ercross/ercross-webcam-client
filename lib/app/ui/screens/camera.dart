import 'package:ercross/app/data/web_rtc_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../colors.dart';

class CameraScreen extends StatefulWidget {
  final WebRTCConnection connection;
  const CameraScreen({required this.connection, super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  // @override
  // didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.inactive) {
  //     widget.feedProvider.cameraController.dispose();
  //   } else if (state == AppLifecycleState.resumed) {
  //     widget.feedProvider.start();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              size: 18,
            )),
        backgroundColor: AppColor.backgroundWhite,
        centerTitle: true,
        title: Text("Camera", style: Theme.of(context).textTheme.bodyLarge),
      ),
      body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(18, 20, 18, 10),
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: RTCVideoView(
                    widget.connection.localRenderer,
                    filterQuality: FilterQuality.medium,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    mirror: true,
                  )),
              /*Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child:
                      _CameraFeedControlBox(widget.connection.cameraController))*/
            ],
          )),
    );
  }
}

class _CameraToolBox extends StatelessWidget {
  const _CameraToolBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black12,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 202, 225, 240),
              blurRadius: 5.0,
              spreadRadius: 1.0,
              offset: Offset(-1, 1), // changes position of shadow
            ),
          ]),
    );
  }
}
