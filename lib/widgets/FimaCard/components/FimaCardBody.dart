import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../FimaCard.dart';


class FimaCardBody extends HookWidget {
    const FimaCardBody({
        Key key,
        @required this.title,
        @required this.actionPosition,
        @required this.actionType,
        this.onTap,
        this.contentBuilder,
        this.openContentBuilder,
        this.contentPadding = const EdgeInsets.all(16),
    }) : super(key: key);

    final String title;
    final VoidCallback onTap;
    final Widget Function(BuildContext context, bool isOpen) contentBuilder;
    final Widget Function(BuildContext context) openContentBuilder;
    final EdgeInsets contentPadding;
    final ActionType actionType;

    final ActionPosition actionPosition;

    @override
    Widget build(BuildContext context) {
        final isOpenController = useState<bool>(false);
        var padding = contentPadding;
        if (actionPosition == ActionPosition.left) padding = padding.add(EdgeInsets.only(left: actionType == ActionType.indicator ? 32 : 100));

        return GestureDetector(
            child: Container(
                child: Column(
                    children: [
                        title != null && title.length > 0
                            ? Text(
                                title,
                                style: TextStyle(
                                    fontSize: 21,
                                    color: Colors.grey[600],
                                ),
                            )
                            : Container(),
                        contentBuilder(context, isOpenController.value),
                        isOpenController.value && openContentBuilder != null
                            ? openContentBuilder(context)
                            : Container()
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                ),
                height: isOpenController.value ? null : 100,
                color: Colors.transparent,
                padding: padding,// EdgeInsets.fromLTRB(actionPosition == ActionPosition.left ? 116 : 16, 16, 16, 16),
            ),
            onTap: () {
                isOpenController.value = !isOpenController.value;
                if (onTap != null) onTap();
            },
        );
    }
}
