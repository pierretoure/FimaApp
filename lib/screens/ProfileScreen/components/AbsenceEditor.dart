import 'package:FimaApp/modals/Meal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'ToggleMealButton.dart';

class AbsenceEditor extends StatelessWidget {
    const AbsenceEditor({
        Key key,
        @required this.date,
        @required this.isPresentAtLunch,
        @required this.isPresentAtDinner,
        this.onToggleAbsence,
    }) : super(key: key);

    final DateTime date;
    final void Function(DateTime, Meal) onToggleAbsence;
    final bool isPresentAtLunch;
    final bool isPresentAtDinner;

    @override
    Widget build(BuildContext context) {
        return Container(
            child: Column(
                children: [
                    Container(
                        child: Center(
                            child: Text(
                                DateFormat.MMMEd('fr_FR').format(date),
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.grey[700],
                                ),
                            ),
                        ),
                        height: 58,
                    ),
                    Row(
                        children: [
                            Container(
                                child: ToggleMealButton(
                                    meal: Meal.LUNCH,
                                    onPressed: () => onToggleAbsence(date, Meal.LUNCH),
                                    isPresent: isPresentAtLunch,
                                ),
                                width: 100, 
                                height: 74,
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            ),
                            Container(
                                child: ToggleMealButton(
                                    meal: Meal.DINNER,
                                    onPressed: () => onToggleAbsence(date, Meal.DINNER),
                                    isPresent: isPresentAtDinner,
                                ),
                                width: 100, 
                                height: 74,
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            ),
                        ],
                    )
                ],
            ),
            width: 200,
        );
    }
}
