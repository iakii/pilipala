import 'package:flutter/material.dart';

class CustomScrollBehaviour extends MaterialScrollBehavior {
  const CustomScrollBehaviour();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    switch (getPlatform(context)) {
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      // return Scrollbar(
      //   controller: details.controller,
      //   child: child,
      // );
      case TargetPlatform.windows:
        return Scrollbar(
          controller: details.controller,
          radius: Radius.zero,
          thickness: 8.0,
          child: child,
        );
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
        return child;
    }
  }
}
