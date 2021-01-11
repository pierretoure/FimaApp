import 'package:flutter/material.dart';

const Color GREY_COLOR = Color(0xff777777);

class Tag extends StatelessWidget {
    const Tag({
        Key key,
        @required this.label,
        this.color,
        this.isGrey = false,
        this.onTap,
    }) : super(key: key);

    final String label;
    final Color color;
    final bool isGrey;
    final void Function() onTap;

    @override
    Widget build(BuildContext context) {
        Color tagColor = isGrey 
        ? GREY_COLOR
        : color ?? GREY_COLOR;
        return GestureDetector(
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                    color: tagColor.withAlpha(50),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                child: Text(
                    label,
                    style: TextStyle(
                        color: tagColor,
                    ),
                ),
            ),
            onTap: onTap,
        );
    }
}