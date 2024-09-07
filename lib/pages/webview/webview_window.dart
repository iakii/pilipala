import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/pages/desktop/index.dart';
import 'package:pilipala/pages/home/controller.dart';
import 'package:pilipala/pages/media/controller.dart';
import 'package:pilipala/services/loggeer.dart';
import 'package:pilipala/utils/login.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:window_manager/window_manager.dart';

class WebLogin {
  static Future<void> login() async {
    final webview = await WebviewWindow.create(
      configuration: CreateConfiguration(
        windowHeight: 667,
        windowWidth: 375,
        title: '登录bilibili',
        titleBarHeight: kWindowCaptionHeight.toInt(),
      ),
    );
    webview
      ..setApplicationNameForUserAgent(Request().headerUa())
      ..openDevToolsWindow()
      ..addOnWebMessageReceivedCallback((message) {
        getLogger().d("addOnWebMessageReceivedCallback  $message");
      })
      ..setOnUrlRequestCallback((url) {
        if (url.startsWith('https://passport.bilibili.com/web/sso/exchange_cookie') || url.startsWith('https://m.bilibili.com/')) {
          webview.getAllCookies().then((cookies) async {
            // getLogger().e(cookies.map((e) => e.toJson()).toList());

            if (cookies.isNotEmpty) {
              var cookieString = cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

              Request.dio.options.headers['cookie'] = cookieString;

              confirmLogin(url, webview);
            }
          });
        }
        return true;
      })
      ..launch('https://passport.bilibili.com/h5-app/passport/login');
  }

  static Future<void> confirmLogin(url, Webview webview) async {
    var content = '';
    if (url != null) {
      content = '${content + url}; \n';
    }
    try {
      final result = await UserHttp.userInfo();
      if (result['status'] && result['data'].isLogin) {
        SmartDialog.showToast('登录成功');
        try {
          Box userInfoCache = GStrorage.userInfo;
          await userInfoCache.put('userInfoCache', result['data']);

          final HomeController homeCtr = Get.find<HomeController>();
          homeCtr.updateLoginStatus(true);
          homeCtr.userFace.value = result['data'].face;
          await LoginUtils.refreshLoginStatus(true);

          final MediaController mediaCtr = Get.find<MediaController>();
          mediaCtr.mid = result['data'].mid;
        } catch (err) {
          SmartDialog.show(builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('登录遇到问题'),
              content: Text(err.toString()),
              actions: [
                TextButton(
                  onPressed: () => webview.reload(),
                  child: const Text('确认'),
                )
              ],
            );
          });
        }
        getBack();
      } else {
        // 获取用户信息失败
        SmartDialog.showToast(result['msg']);
        Clipboard.setData(ClipboardData(text: result['msg']));
      }
    } catch (e) {
      SmartDialog.showNotify(msg: e.toString(), notifyType: NotifyType.warning);
      content = content + e.toString();
      Clipboard.setData(ClipboardData(text: content));
    }
  }
}
