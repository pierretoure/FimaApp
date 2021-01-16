import 'package:FimaApp/widgets/FimaCard/FimaCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FimaCardAction<T> extends HookWidget {
    const FimaCardAction({
        Key key,
        @required this.iconData,
        @required this.iconColor,
        @required this.color,
        this.onTap,
        this.actionType = ActionType.square,
    }) : super(key: key);

    final IconData iconData;
    final Color color;
    final Color iconColor;
    final VoidCallback onTap;

    final ActionType actionType;

    @override
    Widget build(BuildContext context) {
        return actionType == ActionType.indicator
            ? Container(
                width: 28,
                height: 100,
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(32)),
                ),
            )
            : GestureDetector(
                child: Container(
                    child: Center(
                        child: Icon(
                            iconData,
                            color: iconColor,
                            size: 50,
                        ),
                    ),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                        color: color,
                        boxShadow: [
                            BoxShadow(blurRadius: 10, spreadRadius: 1, color: Colors.black.withAlpha(20))
                        ],
                    ),
                ),
                onTap: onTap,
            );
    }
}
