import 'package:get/get.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/main/index.dart';

class DesktopController extends GetxController {
  final MainController _mainController = Get.put(MainController(), permanent: true);
  final HomeController _homeController = Get.put(HomeController(), permanent: true);

  DesktopController();

  final desktopRoute = Get.nestedKey("/desktop");

  final delegate = GetDelegate();

  final routeUrl = ["/home", "/rank", "/dynamics", "/media"];

  int index = 0;

  List get items {
    return _mainController.navigationBars;
  }

  Future<void> toNamed<T>(String route, {dynamic arguments, Map<String, String>? parameters}) async {
    final destRoute = "/desktop$route";

    if (delegate.history.where((element) => element.currentPage?.name == destRoute).isNotEmpty) {
      await delegate.backUntil(destRoute, popMode: PopMode.History);
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
    if (this.index == index) return;
    toNamed(routeUrl[index]);
    this.index = index;
    update(["desktop"]);
  }

  _initData() {
    update(["desktop"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

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

Future<void> getToNamed(String route, {dynamic arguments, Map<String, String>? parameters}) async {
  if (GetPlatform.isDesktop) {
    await Get.find<DesktopController>().toNamed(route, arguments: arguments, parameters: parameters);
  } else {
    await Get.toNamed(route, arguments: arguments, parameters: parameters);
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
