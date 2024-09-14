import 'dart:developer';
import 'dart:ui';

import 'package:ercross/app/data/key_value_storage.dart';
import 'package:ercross/app/ui/screens/home/home.dart';
import 'package:ercross/app/ui/theme.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _handleErrors();
  await KeyValueStorage.init();
  runApp(const ErcrossWebcam());
}

class ErcrossWebcam extends StatelessWidget {
  const ErcrossWebcam({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ercross Webcam',
      theme: AppTheme.lightMode,
      home: const HomeScreen(),
    );
  }
}

_handleErrors() {
  FlutterError.onError = (details) {
    log("[UI RENDERING ERROR]: ${details.exceptionAsString()}",
        stackTrace: details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log("[PLATFORM ERROR]: ${error.toString()}", stackTrace: stack);
    return true;
  };
}
