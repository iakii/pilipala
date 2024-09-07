import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/video.dart';
import '../../../../models/model_hot_video_item.dart';
import 'package:pilipala/pages/desktop/index.dart';

class ReleatedController extends GetxController {
  // 视频aid
  String bvid = getParameters['bvid'] ?? "";
  // 推荐视频列表
  RxList relatedVideoList = <HotVideoItemModel>[].obs;

  OverlayEntry? popupDialog;

  Future<dynamic> queryRelatedVideo() async {
    return VideoHttp.relatedVideoList(bvid: bvid).then((value) {
      if (value['status']) {
        relatedVideoList.value = value['data'];
      }
      return value;
    });
  }
}
