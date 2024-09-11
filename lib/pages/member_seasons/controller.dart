import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/models/member/seasons.dart';
import 'package:pilipala/router/navigator.dart';

class MemberSeasonsController extends GetxController {
  final ScrollController scrollController = ScrollController();
  late int mid;
  late int seasonId;
  int pn = 1;
  int ps = 30;
  int count = 0;
  RxList<MemberArchiveItem> seasonsList = <MemberArchiveItem>[].obs;
  late Map page;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(getParameters['mid']!);
    seasonId = int.parse(getParameters['seasonId']!);
  }

  // 获取专栏详情
  Future getSeasonDetail(type) async {
    if (type == 'onRefresh') {
      pn = 1;
    }
    var res = await MemberHttp.getSeasonDetail(
      mid: mid,
      seasonId: seasonId,
      pn: pn,
      ps: ps,
      sortReverse: false,
    );
    if (res['status']) {
      seasonsList.addAll(res['data'].archives);
      page = res['data'].page;
      pn += 1;
    }
    return res;
  }

  // 上拉加载
  Future onLoad() async {
    getSeasonDetail('onLoad');
  }
}
