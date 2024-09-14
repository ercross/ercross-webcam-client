// ignore_for_file: use_build_context_synchronously
import 'dart:math';
import 'package:ercross/app/data/web_rtc_connection.dart';
import 'package:ercross/app/ui/screens/camera.dart';
import 'package:ercross/app/ui/screens/signal_server_address_config.dart';
import 'package:ercross/app/ui/value_notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../colors.dart';
import '../../shared_widgets/overlay/overlay.dart';

part 'widgets/dashed_circle_painter.dart';
part 'widgets/power_switch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WebRTCConnection? _connection;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColor.primary,
      statusBarIconBrightness:
          Brightness.light, // For light icons on a dark background
      statusBarBrightness:
          Brightness.dark, // For dark icons on a light background
    ));
    return Scaffold(
        appBar: AppBar(
          title: Text("Ercross Webcam",
              style: Theme.of(context).textTheme.bodyLarge),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CircleAvatar(
                radius: 15,
                foregroundImage: Image.asset(
                  "assets/images/webcam.png",
                  height: 40,
                  width: 40,
                  fit: BoxFit.contain,
                ).image,
              ),
            ),
          ],
        ),
        body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(18, 20, 18, 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ValueListenableBuilder(
              valueListenable: videoFeedConnectionStateNotifier,
              builder: (_, connectionState, __) => _PowerSwitchButton(
                state: connectionState,
                onPressed: _toggleConnection,
                size: 200.0,
                label: _connectionStatusText(connectionState),
                backgroundColor: Colors.grey[200]!,
                iconColor: Colors.white,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
                onPressed: _gotoConnectionConfigurationScreen,
                child: const Text("Edit Connection")),
            const SizedBox(height: 10),
            Text("Signal server address configuration\n",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
            ValueListenableBuilder(
                valueListenable: ipAddressValueNotifier,
                builder: (_, ipAddress, __) {
                  return Text("Ip Address: ${ipAddress ?? "Not configured"}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall);
                }),
            const SizedBox(height: 8),
            ValueListenableBuilder(
                valueListenable: portValueNotifier,
                builder: (_, port, __) {
                  return Text("Port: ${port ?? "Not configured"}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall);
                })
          ]),
        ));
  }

  _toggleConnection() async {
    if (ipAddressValueNotifier.value == null ||
        portValueNotifier.value == null) {
      AppOverlay.showSnackBar(
        context,
        "Must provide valid signal server configuration parameters",
      );
      return;
    }

    _connection ??= WebRTCConnection(
        signalingServerIPAddress: ipAddressValueNotifier.value!,
        signalingServerPort: portValueNotifier.value!);

    // disconnect if currently connected
    if (videoFeedConnectionStateNotifier.value ==
        WebRTCConnectionState.connected) {
      videoFeedConnectionStateNotifier.value =
          WebRTCConnectionState.disconnecting;
      await _connection!.terminate();
      _connection = null;
      videoFeedConnectionStateNotifier.value =
          WebRTCConnectionState.disconnected;
      return;
    }

    // connect if currently disconnected
    if (videoFeedConnectionStateNotifier.value ==
        WebRTCConnectionState.disconnected) {
      videoFeedConnectionStateNotifier.value = WebRTCConnectionState.connecting;

      try {
        await _connection!.start();
      } catch (e) {
        AppOverlay.showErrorInfo(
            context, "Error encountered while initializing video feed: $e");
        return;
      }
      videoFeedConnectionStateNotifier.value = WebRTCConnectionState.connected;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CameraScreen(connection: _connection!)));
    }
  }

  _gotoConnectionConfigurationScreen() => Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ConnectionConfigurationScreen()));

  String _connectionStatusText(WebRTCConnectionState state) {
    switch (state) {
      case WebRTCConnectionState.connecting:
        return "Connecting...";
      case WebRTCConnectionState.connected:
        return "Connected";
      case WebRTCConnectionState.disconnected:
        return "Disconnected";
      case WebRTCConnectionState.disconnecting:
        return "Disconnecting...";
      default:
        return "Unknown state";
    }
  }
}
