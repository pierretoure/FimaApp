import 'dart:async';

import 'package:flutter/material.dart';

class FimaFlatButton extends StatelessWidget {

    const FimaFlatButton({
        Key key,
        @required this.title,
        this.isActive = false,
        this.onPressed,
    });

    final String title;
    final bool isActive;
    final FutureOr<VoidCallback> onPressed;

    @override
    Widget build(BuildContext context) {
        return FlatButton(
            child: Text(
                title,
                style: TextStyle(
                    fontSize: 18,
                    color: isActive ? Colors.blueAccent : Colors.grey
                ),
            ),
            onPressed: onPressed,
        );
    }
}