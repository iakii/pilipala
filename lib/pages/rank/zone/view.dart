import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/animated_dialog.dart';
import 'package:pilipala/common/widgets/overlay_pop.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/video_card_h.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/main/index.dart';
import 'package:pilipala/pages/rank/zone/index.dart';

class ZonePage extends StatefulWidget {
  const ZonePage({Key? key, required this.rid}) : super(key: key);

  final int rid;

  @override
  State<ZonePage> createState() => _ZonePageState();
}

class _ZonePageState extends State<ZonePage>
    with AutomaticKeepAliveClientMixin {
  late ZoneController _zoneController;
  List videoList = [];
  Future? _futureBuilderFuture;
  late ScrollController scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _zoneController = Get.put(ZoneController(), tag: widget.rid.toString());
    _futureBuilderFuture = _zoneController.queryRankFeed('init', widget.rid);
    scrollController = _zoneController.scrollController;
    StreamController<bool> mainStream =
        Get.find<MainController>().bottomBarStream;
    StreamController<bool> searchBarStream =
        Get.find<HomeController>().searchBarStream;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          if (!_zoneController.isLoadingMore) {
            _zoneController.isLoadingMore = true;
            _zoneController.onLoad();
          }
        }

        final ScrollDirection direction =
            scrollController.position.userScrollDirection;
        if (direction == ScrollDirection.forward) {
          mainStream.add(true);
          searchBarStream.add(true);
        } else if (direction == ScrollDirection.reverse) {
          mainStream.add(false);
          searchBarStream.add(false);
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        return await _zoneController.onRefresh();
      },
      child: CustomScrollView(
        controller: _zoneController.scrollController,
        slivers: [
          SliverPadding(
            // 单列布局 EdgeInsets.zero
            padding:
                const EdgeInsets.fromLTRB(0, StyleString.safeSpace - 5, 0, 0),
            sliver: FutureBuilder(
              future: _futureBuilderFuture,
              builder: (context, snapshot) {
                final width = MediaQuery.of(context).size.width;
                final crossAxisCount = ((width - 66) / 375).floor();
                final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount, //Grid按两列显示
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 4.0,
                );

                if (snapshot.connectionState == ConnectionState.done) {
                  Map data = snapshot.data as Map;

                  if (data['status']) {
                    return Obx(
                      () => SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return VideoCardH(
                              videoItem: _zoneController.videoList[index],
                              showPubdate: true,
                              longPress: () {
                                _zoneController.popupDialog =
                                    _createPopupDialog(
                                        _zoneController.videoList[index]);
                                Overlay.of(context)
                                    .insert(_zoneController.popupDialog!);
                              },
                              longPressEnd: () {
                                _zoneController.popupDialog?.remove();
                              },
                            );
                          },
                          childCount: _zoneController.videoList.length,
                        ),
                        gridDelegate: gridDelegate,
                      ),
                    );
                  } else {
                    return HttpError(
                      errMsg: data['msg'],
                      fn: () {
                        setState(() {
                          _futureBuilderFuture =
                              _zoneController.queryRankFeed('init', widget.rid);
                        });
                      },
                    );
                  }
                } else {
                  // 骨架屏
                  return SliverGrid(
                    gridDelegate: gridDelegate,
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return const VideoCardHSkeleton();
                    }, childCount: 10),
                  );
                }
              },
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.bottom + 10,
            ),
          )
        ],
      ),
    );
  }

  OverlayEntry _createPopupDialog(videoItem) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        closeFn: _zoneController.popupDialog?.remove,
        child: OverlayPop(
            videoItem: videoItem, closeFn: _zoneController.popupDialog?.remove),
      ),
    );
  }
}
