import 'package:get/get.dart';
import 'package:pilipala/pages/desktop/index.dart';
import 'package:pilipala/pages/webview/webview_window.dart';

Future<void> getToNamed<T>(
  String route, {
  dynamic arguments,
  Map<String, String>? parameters,
  int? id,
  bool preventDuplicates = true,
}) async {
  if (GetPlatform.isDesktop) {
    // getLogger
    if (["/webview", "/loginPage"].contains(route)) {
      final url = parameters?['url'] ??
          "https://passport.bilibili.com/h5-app/passport/login";
      final type = parameters?['type'] ?? "login";
      final title = parameters?['pageTitle'] ?? "登录bilibili";
      return await DesktopWebview.login(url, type, title);
    }
    await Get.find<DesktopController>().delegate.toNamed<T>("/desktop$route",
        arguments: arguments, parameters: parameters);
  } else {
    await Get.toNamed<T>(
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
    await Get.find<DesktopController>().delegate.offNamed("/desktop$route",
        arguments: arguments, parameters: parameters);
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

// final desktopDelegate = Get.find<DesktopController>().delegate;

void getBack<T>(
    {T? result, bool closeOverlays = false, bool canPop = true, int? id}) {
  if (GetPlatform.isDesktop) {
    Get.find<DesktopController>()
        .delegate
        .popRoute(result: result, popMode: PopMode.History);
  } else {
    Get.back(
        result: result, closeOverlays: closeOverlays, canPop: canPop, id: id);
  }
}
