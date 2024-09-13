import 'package:flutter/material.dart';

import '../loading_indicator.dart';

part 'background.dart';
part 'error_dialog.dart';

class AppOverlay {
  static OverlayEntry? _loadingIndicatorEntry;
  static final Map<int, OverlayEntry> _entries = {};

  static showErrorInfo(BuildContext context, Object? error) {
    final uniqueKey = DateTime.now().microsecondsSinceEpoch;
    OverlayEntry? errorEntry;
    errorEntry = OverlayEntry(builder: (context) {
      return _OverlayBackground(
          absorbPointer: false,
          child: _OverlayDialogShape(
              child: _ErrorDialog(
            error: error.toString(),
            onPressedOkayButton: () => dismissErrorDialog(uniqueKey),
          )));
    });

    _entries[uniqueKey] = errorEntry;
    Overlay.of(context).insert(errorEntry);
  }

  static dismissErrorDialog(int uniqueKey) {
    final entry = _entries[uniqueKey];
    if (entry != null) {
      entry.remove();
      _entries.remove(uniqueKey);
    }
  }

  static showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        backgroundColor: Colors.black12,
        content: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white),
        )));
  }

  static showLoadingIndicator(context) {
    if (_loadingIndicatorEntry != null) {
      return;
    }
    _loadingIndicatorEntry = OverlayEntry(builder: (context) {
      return _OverlayBackground(
        absorbPointer: true,
        child: Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: const AppLoadingIndicator(),
        ),
      );
    });
    Overlay.of(context).insert(_loadingIndicatorEntry!);
  }

  static dismissLoadingIndicator() {
    if (_loadingIndicatorEntry == null) {
      return;
    }

    _loadingIndicatorEntry!.remove();
    _loadingIndicatorEntry = null;
  }
}
