import 'dart:io';

import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/plugin/pl_player/index.dart';
import 'package:pilipala/router/navigator.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:window_manager/window_manager.dart';

import 'controller.dart';
import 'widgets/bottom_control.dart';

class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key});

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  final LiveRoomController _liveRoomController = Get.put(LiveRoomController());
  PlPlayerController? plPlayerController;
  late Future? _futureBuilder;
  late Future? _futureBuilderFuture;

  bool isShowCover = true;
  bool isPlay = true;
  Floating? floating;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      floating = Floating();
    }
    videoSourceInit();
    _futureBuilderFuture = _liveRoomController.queryLiveInfo();
  }

  Future<void> videoSourceInit() async {
    _futureBuilder = _liveRoomController.queryLiveInfoH5();
    plPlayerController = _liveRoomController.plPlayerController;
  }

  @override
  void dispose() {
    plPlayerController!.dispose();
    if (floating != null) {
      floating!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget videoPlayerPanel = FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data['status']) {
          return PLVideoPlayer(
            controller: plPlayerController!,
            bottomControl: BottomControl(
              controller: plPlayerController,
              liveRoomCtr: _liveRoomController,
              floating: floating,
            ),
            headerControl: PreferredSize(
                preferredSize: const Size.fromHeight(kWindowCaptionHeight),
                child: Row(
                  children: [
                    ComBtn(
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                      fuc: () {
                        plPlayerController?.videoPlayerClosed();
                        getBack();
                      },
                    ),
                    Text("${_liveRoomController.liveItem.title} 观看${_liveRoomController.liveItem.online}人")
                        .textColor(Colors.white)
                  ],
                )),
          );
        } else {
          return const SizedBox();
        }
      },
    );

    final windowHeight = MediaQuery.sizeOf(context).height;
    final landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final height = windowHeight - kWindowCaptionHeight;

    Widget childWhenDisabled = Scaffold(
      primary: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/images/live/default_bg.webp',
                fit: BoxFit.cover,
                // width: Get.width,
                // height: Get.height,
              ),
            ),
          ),
          Obx(
            () => Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _liveRoomController
                              .roomInfoH5.value.roomInfo?.appBackground !=
                          '' &&
                      _liveRoomController
                              .roomInfoH5.value.roomInfo?.appBackground !=
                          null
                  ? Opacity(
                      opacity: 0.8,
                      child: NetworkImgLayer(
                        width: Get.width,
                        height: Get.height,
                        type: 'bg',
                        src: _liveRoomController
                                .roomInfoH5.value.roomInfo?.appBackground ??
                            '',
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
          Column(
            children: [
              AppBar(
                centerTitle: false,
                titleSpacing: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                toolbarHeight:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 56
                        : 0,
                title: FutureBuilder(
                  future: _futureBuilder,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const SizedBox();
                    }
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      return Obx(
                        () => Row(
                          children: [
                            NetworkImgLayer(
                              width: 34,
                              height: 34,
                              type: 'avatar',
                              src: _liveRoomController
                                  .roomInfoH5.value.anchorInfo!.baseInfo!.face,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _liveRoomController.roomInfoH5.value
                                      .anchorInfo!.baseInfo!.uname!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 1),
                                if (_liveRoomController
                                        .roomInfoH5.value.watchedShow !=
                                    null)
                                  Text(
                                    _liveRoomController.roomInfoH5.value
                                            .watchedShow!['text_large'] ??
                                        '',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              PopScope(
                canPop: plPlayerController?.isFullScreen.value != true,
                onPopInvokedWithResult: (bool didPop, _) {
                  if (plPlayerController?.isFullScreen.value == true) {
                    plPlayerController!.triggerFullScreen(status: false);
                  }
                  if (MediaQuery.of(context).orientation ==
                      Orientation.landscape) {
                    verticalScreen();
                  }
                },
                child: SizedBox(
                  width: Get.size.width,
                  height: landscape ? height : Get.size.width * 9 / 16,
                  child: videoPlayerPanel.clipRRect(all: 6).elevation(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (Platform.isAndroid) {
      return PiPSwitcher(
        childWhenDisabled: childWhenDisabled,
        childWhenEnabled: videoPlayerPanel,
        floating: floating,
      );
    } else {
      return childWhenDisabled;
    }
  }
}
