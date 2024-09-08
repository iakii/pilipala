import 'package:flutter/widgets.dart';

import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';

import 'behaviour.dart';

class ScrollBar extends StatelessWidget {
  const ScrollBar(
      {super.key, required this.scrollController, required this.child});
  final ScrollController scrollController;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ImprovedScrolling(
      scrollController: scrollController,
      onScroll: (scrollOffset) => debugPrint(
        'Scroll offset: $scrollOffset',
      ),
      onMMBScrollStateChanged: (scrolling) => debugPrint(
        'Is scrolling: $scrolling',
      ),
      onMMBScrollCursorPositionUpdate: (localCursorOffset, scrollActivity) =>
          debugPrint(
        'Cursor position: $localCursorOffset\n'
        'Scroll activity: $scrollActivity',
      ),
      enableMMBScrolling: true,
      enableKeyboardScrolling: true,
      enableCustomMouseWheelScrolling: true,
      // mmbScrollConfig: const MMBScrollConfig(
      //   customScrollCursor: DefaultCustomScrollCursor(),
      // ),
      keyboardScrollConfig: KeyboardScrollConfig(
        arrowsScrollAmount: 250.0,
        homeScrollDurationBuilder: (currentScrollOffset, minScrollOffset) {
          return const Duration(milliseconds: 100);
        },
        endScrollDurationBuilder: (currentScrollOffset, maxScrollOffset) {
          return const Duration(milliseconds: 2000);
        },
      ),
      customMouseWheelScrollConfig: const CustomMouseWheelScrollConfig(
        scrollAmountMultiplier: 4.0,
        scrollDuration: Duration(milliseconds: 350),
      ),
      child: ScrollConfiguration(
          behavior: const CustomScrollBehaviour(), child: child),
    );
  }
}
