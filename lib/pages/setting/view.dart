import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/pages/desktop/controller.dart';
import 'package:pilipala/pages/setting/index.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingController settingController = Get.put(SettingController());
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => getBack(),
        ),
        title: Text('设置', style: Theme.of(context).textTheme.titleMedium),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () => getToNamed('/privacySetting'),
            dense: false,
            title: const Text('隐私设置'),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            onTap: () => getToNamed('/recommendSetting'),
            dense: false,
            title: const Text('推荐设置'),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            onTap: () => getToNamed('/playSetting'),
            dense: false,
            title: const Text('播放设置'),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            onTap: () => getToNamed('/styleSetting'),
            dense: false,
            title: const Text('外观设置'),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            onTap: () => getToNamed('/extraSetting'),
            dense: false,
            title: const Text('其他设置'),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
          Obx(
            () => Visibility(
              visible: settingController.userLogin.value,
              child: ListTile(
                // trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () => settingController.loginOut(),
                dense: false,
                title: const Text('退出登录'),
              ),
            ),
          ),
          ListTile(
            onTap: () => getToNamed('/about'),
            dense: false,
            title: const Text('关于'),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
        ],
      ),
    );
  }
}
