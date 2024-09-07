import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/constants.dart';
import 'package:pilipala/http/live.dart';
import 'package:pilipala/models/live/quality.dart';
import 'package:pilipala/models/live/room_info.dart';
import 'package:pilipala/plugin/pl_player/index.dart';
import '../../models/live/room_info_h5.dart';
import '../../utils/storage.dart';
import '../../utils/video_utils.dart';
import 'package:pilipala/pages/desktop/index.dart';

class LiveRoomController extends GetxController {
  String cover = '';
  late int roomId;
  dynamic liveItem;
  late String heroTag;
  double volume = 0.0;
  // 静音状态
  RxBool volumeOff = false.obs;
  PlPlayerController plPlayerController =
      PlPlayerController.getInstance(videoType: 'live');
  Rx<RoomInfoH5Model> roomInfoH5 = RoomInfoH5Model().obs;
  late bool enableCDN;
  late int currentQn;
  int? tempCurrentQn;
  late List<Map<String, dynamic>> acceptQnList;
  RxString currentQnDesc = ''.obs;

  @override
  void onInit() {
    super.onInit();
    currentQn = setting.get(SettingBoxKey.defaultLiveQa,
        defaultValue: LiveQuality.values.last.code);
    roomId = int.parse(getParameters['roomid']!);
    if (getArguments != null) {
      liveItem = getArguments['liveItem'];
      heroTag = getArguments['heroTag'] ?? '';
      if (liveItem != null && liveItem.pic != null && liveItem.pic != '') {
        cover = liveItem.pic;
      }
      if (liveItem != null && liveItem.cover != null && liveItem.cover != '') {
        cover = liveItem.cover;
      }
    }
    // CDN优化
    enableCDN = setting.get(SettingBoxKey.enableCDN, defaultValue: true);
  }

  playerInit(source) async {
    await plPlayerController.setDataSource(
      DataSource(
        videoSource: source,
        audioSource: null,
        type: DataSourceType.network,
        httpHeaders: {
          'user-agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15',
          'referer': HttpString.baseUrl
        },
      ),
      // 硬解
      enableHA: true,
      autoplay: true,
    );
  }

  Future queryLiveInfo() async {
    var res = await LiveHttp.liveRoomInfo(roomId: roomId, qn: currentQn);
    if (res['status']) {
      List<CodecItem> codec =
          res['data'].playurlInfo.playurl.stream.first.format.first.codec;
      CodecItem item = codec.first;
      // 以服务端返回的码率为准
      currentQn = item.currentQn!;
      if (tempCurrentQn != null && tempCurrentQn == currentQn) {
        SmartDialog.showToast('画质切换失败，请检查登录状态');
      }
      List acceptQn = item.acceptQn!;
      acceptQnList = acceptQn.map((e) {
        return {
          'code': e,
          'desc': LiveQuality.values
              .firstWhere((element) => element.code == e)
              .description,
        };
      }).toList();
      currentQnDesc.value = LiveQuality.values
          .firstWhere((element) => element.code == currentQn)
          .description;
      String videoUrl = enableCDN
          ? VideoUtils.getCdnUrl(item)
          : (item.urlInfo?.first.host)! +
              item.baseUrl! +
              item.urlInfo!.first.extra!;
      await playerInit(videoUrl);
      return res;
    }
  }

  void setVolumn(value) {
    if (value == 0) {
      // 设置音量
      volumeOff.value = false;
    } else {
      // 取消音量
      volume = value;
      volumeOff.value = true;
    }
  }

  Future queryLiveInfoH5() async {
    var res = await LiveHttp.liveRoomInfoH5(roomId: roomId);
    if (res['status']) {
      roomInfoH5.value = res['data'];
    }
    return res;
  }

  // 修改画质
  void changeQn(int qn) async {
    tempCurrentQn = currentQn;
    if (currentQn == qn) {
      return;
    }
    currentQn = qn;
    currentQnDesc.value = LiveQuality.values
        .firstWhere((element) => element.code == currentQn)
        .description;
    await queryLiveInfo();
  }
}
