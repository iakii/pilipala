import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/pages/dynamics/index.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/main/index.dart';
import 'package:pilipala/pages/media/index.dart';

class DesktopController extends GetxController {
  final MainController _mainController =
      Get.put(MainController(), permanent: true);
  final HomeController _homeController =
      Get.put(HomeController(), permanent: true);
  final DynamicsController namicsController =
      Get.put(DynamicsController(), permanent: true);
  final mediaController = Get.put(MediaController());

  DesktopController();

  final desktopRoute = Get.nestedKey("/desktop");

  final delegate = GetDelegate(
    notFoundRoute: GetPage(
      name: "/notfound",
      page: () => const Scaffold(
        body: Center(
          child: Text("404"),
        ),
      ),
    ),
  );

  final routeUrl = ["/home", "/rank", "/dynamics", "/media"];

  int index = 0;

  List get items {
    return _mainController.navigationBars;
  }

  Future<void> toNamed<T>(String route,
      {dynamic arguments, Map<String, String>? parameters}) async {
    final destRoute = "/desktop$route";
    final config = delegate.history
        .where((element) => element.currentPage?.name == destRoute)
        .firstOrNull;

    if (config != null) {
      await delegate.setRestoredRoutePath(config);
      return;
    }

    await delegate.toNamed<T>(destRoute,
        arguments: arguments, parameters: parameters);
  }

  RxBool get isUserLogin {
    return ctx.userLogin;
  }

  HomeController get ctx {
    return _homeController;
  }

  onTabpanel(int index) {
    // if (this.index == index) return;
    toNamed(routeUrl[index]);
    this.index = index;
    update(["desktop"]);
  }

  _initData() {
    update(["desktop"]);
  }

  void onTap() {}

  @override
  void onInit() {
    delegate.addListener(() {
      final routeName = delegate.currentConfiguration?.currentPage?.name;

      if (routeName == "/desktop/home") {
        index = 0;
      } else if (routeName == "/desktop/rank") {
        index = 1;
      } else if (routeName == "/desktop/dynamics") {
        index = 2;
      } else if (routeName == "/desktop/media") {
        index = 3;
      } else {
        index = -1;
      }
      update(["desktop"]);
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }
}
