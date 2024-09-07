import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/models/video_detail_res.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/utils/id_utils.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:pilipala/pages/desktop/index.dart';

class SeasonPanel extends StatefulWidget {
  const SeasonPanel({
    super.key,
    required this.ugcSeason,
    this.cid,
    this.sheetHeight,
    this.changeFuc,
  });
  final UgcSeason ugcSeason;
  final int? cid;
  final double? sheetHeight;
  final Function? changeFuc;

  @override
  State<SeasonPanel> createState() => _SeasonPanelState();
}

class _SeasonPanelState extends State<SeasonPanel> {
  late List<EpisodeItem> episodes;
  late int cid;
  late int currentIndex;
  final String heroTag = getArguments['heroTag'];
  late VideoDetailController _videoDetailController;
  final ScrollController _scrollController = ScrollController();
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    cid = widget.cid!;
    _videoDetailController = Get.find<VideoDetailController>(tag: heroTag);

    /// 根据 cid 找到对应集，找到对应 episodes
    /// 有多个episodes时，只显示其中一个
    /// TODO 同时显示多个合集
    final List<SectionItem> sections = widget.ugcSeason.sections!;
    for (int i = 0; i < sections.length; i++) {
      final List<EpisodeItem> episodesList = sections[i].episodes!;
      for (int j = 0; j < episodesList.length; j++) {
        if (episodesList[j].cid == cid) {
          episodes = episodesList;
          continue;
        }
      }
    }

    /// 取对应 season_id 的 episodes
    // episodes = widget.ugcSeason.sections!
    //     .firstWhere((e) => e.seasonId == widget.ugcSeason.id)
    //     .episodes!;
    currentIndex = episodes.indexWhere((EpisodeItem e) => e.cid == cid);
    _videoDetailController.cid.listen((int p0) {
      cid = p0;
      setState(() {});
      currentIndex = episodes.indexWhere((EpisodeItem e) => e.cid == cid);
    });
  }

  void changeFucCall(item, int i) async {
    await widget.changeFuc!(
      IdUtils.av2bv(item.aid),
      item.cid,
      item.aid,
    );
    currentIndex = i;
    getBack();
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildEpisodeListItem(
    EpisodeItem episode,
    int index,
    bool isCurrentIndex,
  ) {
    Color primary = Theme.of(context).colorScheme.primary;
    return ListTile(
      onTap: () => changeFucCall(episode, index),
      dense: false,
      leading: isCurrentIndex
          ? Image.asset(
              'assets/images/live.gif',
              color: primary,
              height: 12,
            )
          : null,
      title: Text(
        episode.title!,
        style: TextStyle(
          fontSize: 14,
          color: isCurrentIndex
              ? primary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return Container(
        margin: const EdgeInsets.only(
          top: 8,
          left: 2,
          right: 2,
          bottom: 2,
        ),
        child: Material(
          color: Theme.of(context).colorScheme.onInverseSurface,
          borderRadius: BorderRadius.circular(6),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () => showBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    itemScrollController.jumpTo(index: currentIndex);
                  });
                  return Container(
                    height: widget.sheetHeight,
                    color: Theme.of(context).colorScheme.surface,
                    child: Column(
                      children: [
                        Container(
                          height: 45,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '合集（${episodes.length}）',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.1),
                        ),
                        Expanded(
                          child: Material(
                            child: ScrollablePositionedList.builder(
                              itemCount: episodes.length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                bool isLastItem = index == episodes.length;
                                bool isCurrentIndex = currentIndex == index;
                                return isLastItem
                                    ? SizedBox(
                                        height: MediaQuery.of(context)
                                                .padding
                                                .bottom +
                                            20,
                                      )
                                    : buildEpisodeListItem(
                                        episodes[index],
                                        index,
                                        isCurrentIndex,
                                      );
                              },
                              itemScrollController: itemScrollController,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
              },
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '合集：${widget.ugcSeason.title!}',
                      style: Theme.of(context).textTheme.labelMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Image.asset(
                    'assets/images/live.gif',
                    color: Theme.of(context).colorScheme.primary,
                    height: 12,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${currentIndex + 1}/${episodes.length}',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 13,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
