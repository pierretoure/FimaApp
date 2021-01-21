import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'components/FimaCardAction.dart';
import 'components/FimaCardBody.dart';

class FimaCard extends HookWidget {

    const FimaCard({
        Key key,
        @required this.contentBuilder,
        this.title,
        this.openContentBuilder,
        this.onTap,
        this.actionIconColor = Colors.blueAccent,// const Color(0xFF546E7A), // Equivalent to Colors.blueGrey[600]
        this.actionColor = Colors.white, // Colors.blueGrey,
        this.actionIconData,
        this.onAction,
        this.actionPosition = ActionPosition.right,
        this.contentPadding = const EdgeInsets.all(16),
        this.actionType = ActionType.square,
    }) : super(key: key);
    
    final IconData actionIconData;
    final Color actionColor;
    final Color actionIconColor;
    final VoidCallback onAction;
    final ActionType actionType;
    
    final ActionPosition actionPosition;

    final String title;
    final VoidCallback onTap;
    final Widget Function(BuildContext context, bool isOpen) contentBuilder;
    final Widget Function(BuildContext context) openContentBuilder;
    final EdgeInsets contentPadding;

    @override
    Widget build(BuildContext context) {

        return ConstrainedBox(
            child: Container(
                child: Stack(
                    children: [
                        FimaCardBody(
                            title: title,
                            contentBuilder: contentBuilder,
                            openContentBuilder: openContentBuilder,
                            actionPosition: actionPosition,
                            contentPadding: contentPadding,
                            actionType: actionType,
                            onTap: onTap,
                        ),
                        Positioned(
                            child: FimaCardAction(
                                iconData: actionIconData,
                                color: actionColor,
                                iconColor: actionIconColor,
                                onTap: onAction,
                                actionType: actionType,
                            ),
                            right: actionPosition == ActionPosition.right ? 0 : null,
                            left: actionPosition == ActionPosition.left ? 0 : null,
                        ),
                    ],
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                    color: Colors.grey[200],
                ),
            ),
            constraints: BoxConstraints(
                minHeight: 100,
                minWidth: double.infinity
            ),
        );
    }
}

enum ActionPosition {
    right,
    left
}

enum ActionType {
    square,
    indicator
}