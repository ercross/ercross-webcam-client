import 'package:ercross/app/data/key_value_storage.dart';
import 'package:flutter/material.dart';

import '../data/web_rtc_connection.dart';

ValueNotifier<String?> ipAddressValueNotifier =
    ValueNotifier(KeyValueStorage.ipAddress);
ValueNotifier<String?> portValueNotifier = ValueNotifier(KeyValueStorage.port);
ValueNotifier<WebRTCConnectionState> videoFeedConnectionStateNotifier =
    ValueNotifier(WebRTCConnectionState.disconnected);
