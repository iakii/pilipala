import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/main/index.dart';
import 'package:pilipala/pages/webview/webview_window.dart';

class DesktopController extends GetxController {
  final MainController _mainController = Get.put(MainController());
  final HomeController _homeController = Get.put(HomeController());

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

  Future<void> toNamed<T>(String route, {dynamic arguments, Map<String, String>? parameters}) async {
    final destRoute = "/desktop$route";
    final config = delegate.history.where((element) => element.currentPage?.name == destRoute).firstOrNull;

    if (config != null) {
      await delegate.setRestoredRoutePath(config);
      return;
    }

    await delegate.toNamed<T>(destRoute, arguments: arguments, parameters: parameters);
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

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}

Future<void> getToNamed(
  String route, {
  dynamic arguments,
  Map<String, String>? parameters,
  int? id,
  bool preventDuplicates = true,
}) async {
  if (GetPlatform.isDesktop) {
    if (route == "/webview") {
      return await WebLogin.login();
    }
    await desktopDelegate.toNamed("/desktop$route", arguments: arguments, parameters: parameters);
  } else {
    await Get.toNamed(
      route,
      arguments: arguments,
      parameters: parameters,
      id: id,
      preventDuplicates: preventDuplicates,
    );
  }
}

Future<void> getOffNamed(
  String route, {
  dynamic arguments,
  Map<String, String>? parameters,
  int? id,
  bool preventDuplicates = true,
}) async {
  if (GetPlatform.isDesktop) {
    await desktopDelegate.offNamed("/desktop$route", arguments: arguments, parameters: parameters);
  } else {
    await Get.offNamed(
      route,
      arguments: arguments,
      parameters: parameters,
      id: id,
      preventDuplicates: preventDuplicates,
    );
  }
}

dynamic get getArguments {
  if (GetPlatform.isDesktop) {
    return Get.find<DesktopController>().delegate.arguments();
  } else {
    return Get.arguments;
  }
}

Map<String, String?> get getParameters {
  if (GetPlatform.isDesktop) {
    return Get.find<DesktopController>().delegate.parameters;
  } else {
    return Get.parameters;
  }
}

final desktopDelegate = Get.find<DesktopController>().delegate;

void getBack<T>({T? result, bool closeOverlays = false, bool canPop = true, int? id}) {
  if (GetPlatform.isDesktop) {
    desktopDelegate.popRoute(result: result, popMode: PopMode.History);
  } else {
    Get.back(result: result, closeOverlays: closeOverlays, canPop: canPop, id: id);
  }
}
