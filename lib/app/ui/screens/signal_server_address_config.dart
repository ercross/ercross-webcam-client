// ignore_for_file: use_build_context_synchronously

import 'package:ercross/app/data/key_value_storage.dart';
import 'package:ercross/app/data/web_rtc_connection.dart';
import 'package:ercross/app/ui/colors.dart';
import 'package:ercross/app/ui/value_notifiers.dart';
import 'package:flutter/material.dart';

import '../shared_widgets/overlay/overlay.dart';
import 'camera.dart';

class ConnectionConfigurationScreen extends StatefulWidget {
  const ConnectionConfigurationScreen({super.key});

  @override
  State<ConnectionConfigurationScreen> createState() =>
      _ConnectionConfigurationScreenState();
}

class _ConnectionConfigurationScreenState
    extends State<ConnectionConfigurationScreen> {
  late GlobalKey<FormState> _formKey;

  String? _ipAddress;
  String? _port;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

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
        title:
            Text("Signal server", style: Theme.of(context).textTheme.bodyLarge),
      ),
      body: GestureDetector(
        child: AbsorbPointer(
          absorbing: !(videoFeedConnectionStateNotifier.value ==
              WebRTCConnectionState.disconnected),
          child: SafeArea(
              minimum: const EdgeInsets.fromLTRB(18, 20, 18, 10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "IP Address",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    TextFormField(
                      validator: _validateIPv4Address,
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      onSaved: (value) => _ipAddress = value,
                      decoration:
                          const InputDecoration(hintText: "192.168.0.101"),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Port",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    TextFormField(
                      validator: _validatePort,
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      onSaved: (value) => _port = value,
                      decoration: const InputDecoration(hintText: "8080"),
                    ),
                    const SizedBox(height: 65),
                    ElevatedButton(
                        onPressed: _establishConnection,
                        child: const Text("Establish connection"))
                  ],
                ),
              )),
        ),
      ),
      // prefill with last connection details
    );
  }

  String? _validatePort(String? value) {
    if (value == null) {
      return "Invalid port";
    }
    final port = int.tryParse(value);
    if (port == null) {
      return "Invalid port";
    }

    return null;
  }

  String? _validateIPv4Address(String? value) {
    if (value == null) {
      return "Invalid IPv4 address";
    }
    final isValid = RegExp(r"^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$").hasMatch(value);
    return isValid ? null : "Invalid IPv4 address";
  }

  _establishConnection() async {
    _formKey.currentState!.save();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    AppOverlay.showLoadingIndicator(context);
    KeyValueStorage.updateIpAddress(_ipAddress!);
    KeyValueStorage.updatePort(_port!);

    final connection = WebRTCConnection(
      signalingServerIPAddress: _ipAddress!,
      signalingServerPort: _port!,
    );
    try {
      await connection.start();
    } catch (e) {
      AppOverlay.dismissLoadingIndicator();
      AppOverlay.showErrorInfo(
          context, "Error encountered while initializing video feed: $e");
      return;
    }

    AppOverlay.dismissLoadingIndicator();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => CameraScreen(connection: connection)));
  }
}
