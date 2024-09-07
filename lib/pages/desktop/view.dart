import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/mine/index.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:window_manager/window_manager.dart';

import 'index.dart';

class DestktopApp extends GetView<DesktopController> {
  const DestktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DesktopController>(
      init: DesktopController(),
      id: "desktop",
      builder: (state) {
        return Scaffold(
          body: Row(
            children: [
              SlideNavigation(
                index: state.index,
                onChange: (value) => state.onTabpanel(value),
                items: state.items,
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: kWindowCaptionHeight, child: WindowCaption(brightness: Theme.of(context).brightness)),

                    GetRouterOutlet(
                      initialRoute: "/desktop/home",
                      anchorRoute: "/desktop",
                      key: state.desktopRoute,
                      delegate: state.delegate,
                    ).expanded(),
                    // Row(
                    //   children: [
                    //     Navigator(
                    //   key: state.desktopRoute,
                    //   initialRoute: '/',
                    //   onGenerateRoute: (settings) {
                    //     if (settings.name == '/') {
                    //       return GetPageRoute(page: () => const HomePage());
                    //     } else if (settings.name == '/rank') {
                    //       return GetPageRoute(page: () => const RankPage());
                    //     } else if (settings.name == '/dynamic') {
                    //       return GetPageRoute(page: () => const DynamicsPage());
                    //     } else if (settings.name == '/media') {
                    //       return GetPageRoute(page: () => const MediaPage());
                    //     } else if (settings.name == '/search') {
                    //       return GetPageRoute(page: () => const SearchPage());
                    //     } else if (settings.name == '/setting') {
                    //       return GetPageRoute(page: () => const SettingPage());
                    //     } else if (settings.name == '/login') {
                    //       return GetPageRoute(page: () => const LoginPage());
                    //     }
                    //     return GetPageRoute(page: () => const Text("404"));
                    //   },
                    // ).expanded(),
                    //     Container().backgroundColor(Colors.red).width(375),
                    //   ],
                    // ).expanded(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SlideNavigation extends StatefulWidget {
  const SlideNavigation({super.key, required this.index, required this.onChange, required this.items});
  final int index;
  final Function(int) onChange;
  final List<dynamic> items;

  @override
  State<SlideNavigation> createState() => _SlideNavigationState();
}

class _SlideNavigationState extends State<SlideNavigation> {
  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.home_outlined,
      Icons.trending_up,
      Icons.motion_photos_on_outlined,
      Icons.video_collection_outlined,
    ];
    return Container(
      width: 66,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.primary.withOpacity(0.9), Theme.of(context).colorScheme.primary.withOpacity(0.5), Theme.of(context).colorScheme.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0, 0.0034, 0.34],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          ...widget.items.map((e) {
            final currentIndex = widget.items.indexOf(e);
            final selected = widget.index == currentIndex;
            final selectIconColor = selected ? Colors.white : Colors.black;
            final selectBgColor = selected ? Theme.of(context).primaryColor.withOpacity(1) : Colors.transparent;
            final selectLabelColor = selected ? Theme.of(context).primaryColor.withOpacity(.9) : Colors.black;
            return GestureDetector(
              onTap: () => widget.onChange(currentIndex),
              child: Column(
                children: [
                  Icon(icons[currentIndex], color: selectIconColor)
                      .width(42)
                      .height(42)
                      .ripple()
                      .backgroundGradient(
                        LinearGradient(
                          colors: [selectBgColor, selectBgColor.withOpacity(0.2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      )
                      .clipRRect(all: 24),
                  Text("${e['label']}").textColor(selectLabelColor).fontSize(12),
                ],
              )
                  .parent(({Widget? child}) => MouseRegion(cursor: SystemMouseCursors.click, child: child))
                  .marginOnly(
                    top: 16,
                  )
                  .gestures(
                    onTap: () => widget.onChange(currentIndex),
                  ),
            );
          }).toList(),
          const Spacer(),
          Center(
            child: GetBuilder<DesktopController>(
              builder: (state) {
                final isUserLoggedIn = state.isUserLogin;
                return Column(
                  children: [
                    IconButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                        backgroundColor: WidgetStateProperty.resolveWith((states) {
                          return Theme.of(context).colorScheme.onInverseSurface;
                        }),
                      ),
                      onPressed: () => state.toNamed("/setting"),
                      icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(height: 16),
                    UserInfoWidget(
                      searchBarVisible: false,
                      userLogin: isUserLoggedIn,
                      top: 0,
                      userFace: state.ctx.userFace.value,
                      callback: !isUserLoggedIn.value ? () => state.toNamed("/loginPage") : () => showUserBottomSheet(),
                      ctr: state.ctx,
                    ),
                  ],
                );
              },
            ),
          ).marginOnly(left: 12, bottom: 16)
        ],
      ),
    );
  }

  showUserBottomSheet() {
    feedBack();
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 450,
        width: MediaQuery.of(context).size.width,
        child: const MinePage(),
      ),
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
    );
  }
}
