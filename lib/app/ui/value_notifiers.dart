import 'package:ercross/app/data/key_value_storage.dart';
import 'package:flutter/material.dart';

import '../data/video_feed_provider.dart';

ValueNotifier<String?> ipAddressValueNotifier =
    ValueNotifier(KeyValueStorage.ipAddress);
ValueNotifier<String?> portValueNotifier = ValueNotifier(KeyValueStorage.port);
ValueNotifier<VideoFeedConnectionState> videoFeedConnectionStateNotifier =
    ValueNotifier(VideoFeedConnectionState.disconnected);
