import 'package:get/get.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/main/index.dart';

class DesktopController extends GetxController {
  DesktopController() {
    Get.put(MainController(), permanent: true);
  }

  final desktopRoute = Get.nestedKey(1);

  final routeUrl = ["/", "/rank", "/dynamic", "/media"];

  int index = 0;

  List get items {
    return Get.find<MainController>().navigationBars;
  }

  toName(String route) {
    desktopRoute?.currentState?.pushNamed(route);
  }

  RxBool get isUserLogin {
    return ctx.userLogin;
  }

  HomeController get ctx {
    return Get.find<HomeController>();
  }

  onTabpanel(int index) {
    if (this.index == index) return;
    toName(routeUrl[index]);
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
