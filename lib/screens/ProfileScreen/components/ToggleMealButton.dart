import 'package:FimaApp/modals/Meal.dart';
import 'package:FimaApp/utils/Converters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ToggleMealButton extends HookWidget {
    const ToggleMealButton({
        Key key,
        @required this.meal,
        this.isPresent = true,
        this.onPressed,
    }) : super(key: key);

    final Meal meal;
    final bool isPresent;
    final VoidCallback onPressed;

    @override
    Widget build(BuildContext context) {
        return FlatButton.icon(
            label: Text(
                MealConverter.translateFR(meal),
                style: TextStyle(
                    color: isPresent
                        ? Colors.green
                        : Colors.red,
                ),
            ),
            icon: isPresent
                ? Icon(
                    Icons.check_rounded,
                    color: Colors.green)
                : Icon(
                    Icons.close_rounded,
                    color: Colors.red),
            onPressed: onPressed,
            color: isPresent
                ? Colors.green.withAlpha(50)
                : Colors.red.withAlpha(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
        );
    }
}
