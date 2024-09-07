import 'package:flutter/material.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:styled_widget/styled_widget.dart';

class ActionItem extends StatelessWidget {
  final Icon? icon;
  final Icon? selectIcon;
  final Function? onTap;
  final Function? onLongPress;
  final String? text;
  final bool selectStatus;

  const ActionItem({
    Key? key,
    this.icon,
    this.selectIcon,
    this.onTap,
    this.onLongPress,
    this.text,
    this.selectStatus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        feedBack(),
        onTap!(),
      },
      onLongPress: () => {
        if (onLongPress != null) {onLongPress!()}
      },
      borderRadius: StyleString.mdRadius,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 4),
          selectStatus
              ? Icon(
                  selectIcon!.icon!,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                )
              : Icon(icon!.icon!,
                  size: 18, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 6),
          Text(
            text ?? '',
            style: TextStyle(
              color: selectStatus
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
              fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
            ),
          )
        ],
      ).ripple(),
    ).width(88).height(88);
  }
}
