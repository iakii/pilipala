import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class _SystemWindowManager {
  _SystemWindowManager._();

  static final _SystemWindowManager _instance = _SystemWindowManager._();

  Future<void> init({bool silent = false}) async {
    await windowManager.ensureInitialized();

    if (silent) await windowManager.hide();

    WindowOptions windowOptions = const WindowOptions(
      title: 'PCMaster',
      minimumSize: Size(375, 667),
      size: Size(1366, 768),
      skipTaskbar: true,
      titleBarStyle: TitleBarStyle.hidden,
      alwaysOnTop: false,
      backgroundColor: Colors.transparent,
      windowButtonVisibility: false,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      if (silent) {
        await windowManager.hide();
      } else {
        await windowManager.show();
      }
    });
  }

  Future<void> hide() async {
    await windowManager.hide();
  }

  Future<void> show() async {
    await windowManager.show();
  }
}

final systemWindowManager = _SystemWindowManager._instance;
