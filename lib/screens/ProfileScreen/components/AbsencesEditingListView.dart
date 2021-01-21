import 'package:FimaApp/hooks/UseAbsencesController.dart';
import 'package:FimaApp/modals/Meal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:infinite_listview/infinite_listview.dart';

import 'AbsenceEditor.dart';

class AbsencesEditingListView extends HookWidget {
    const AbsencesEditingListView({
        Key key,
        @required this.controller,
    }) : super(key: key);

    final AbsencesEditingController controller;

    @override
    Widget build(BuildContext context) {
        final update = useValueListenable<AbsencesEditingValue>(controller);

        useEffect(() {
            controller.value = update;
            return null;
        }, [update]);

        return InfiniteListView.builder(
            itemCount: double.maxFinite.toInt(),
            itemBuilder: (context, index) {
                DateTime date = DateTime.now().add(Duration(days: index));
                return AbsenceEditor(
                    date: date,
                    onToggleAbsence: (date, meal) => 
                        controller.toggleAbsence(date, meal),
                    isPresentAtLunch: !update.isAbsent(date, Meal.LUNCH),
                    isPresentAtDinner: !update.isAbsent(date, Meal.DINNER),
                );
            },
            scrollDirection: Axis.horizontal,
        );
    }
}
