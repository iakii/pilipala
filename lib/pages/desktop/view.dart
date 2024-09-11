import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:window_manager/window_manager.dart';

import 'index.dart';
import 'widgets/bg.dart';
import 'widgets/slide_navbar.dart';

class DestktopApp extends GetView<DesktopController> {
  const DestktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DesktopController>(
      init: DesktopController(),
      id: "desktop",
      builder: (state) {
        return Stack(
          children: [
            const GlobalBackground(),
            FutureBuilder(
              builder: (context, snapshot) {
                return Scaffold(
                  body: Row(
                    children: [
                      snapshot.data != true
                          ? SlideNavigation(
                              index: state.index,
                              onChange: (value) => state.onTabpanel(value),
                              items: state.items,
                            )
                          : Container(),
                      Expanded(
                        child: Column(
                          children: [
                            if (snapshot.data != true)
                              SizedBox(
                                  height: kWindowCaptionHeight,
                                  child: WindowCaption(
                                      brightness:
                                          Theme.of(context).brightness)),
                            GetRouterOutlet(
                              initialRoute: "/desktop/home",
                              anchorRoute: "/desktop",
                              key: state.desktopRoute,
                              delegate: state.delegate,
                            ).expanded(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              future: windowManager.isFullScreen(),
            ),
          ],
        );
      },
    );
  }
}
