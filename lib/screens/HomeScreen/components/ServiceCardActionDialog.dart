import 'package:FimaApp/modals/Meal.dart';
import 'package:FimaApp/modals/Service.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:FimaApp/screens/HomeScreen/components/UserTag.dart';
import 'package:FimaApp/utils/Api.dart';
import 'package:FimaApp/widgets/Tag/Tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import 'ServiceCardActionDialogSectionTitle.dart';

class ServiceCardActionDialog extends HookWidget {
    const ServiceCardActionDialog({
        Key key,
        @required this.service,
        @required this.user,
        @required this.asyncCallback,
        this.useMeal = false,
    }) : super(key: key);

    final Service service;
    final User user;
    final bool useMeal;
    final Future<void> Function() asyncCallback;

    @override
    Widget build(BuildContext context) {
        // User
        final selectedUserController = useState<User>(user);

        // Date
        final DateTime initialSelectedDate = DateTime.now();
        final selectedDateController = useState<DateTime>(initialSelectedDate);

        // Meal
        final Meal initialSelectedMeal = DateTime.now().hour < 17 
        ? Meal.LUNCH
        : Meal.DINNER; 
        final selectedMealController = useState<Meal>(initialSelectedMeal);

        return AlertDialog(
            title: Text(
                service.title,
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 23
                ),
            ),
            content: Column(
                children: [
                    buildUserSection(selectedUserController),
                    buildDateSection(context, selectedMealController, selectedDateController),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
            ),
            actions: [
                FlatButton(
                    child: Text(
                        'Annuler',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                        ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                    child: Text(
                        'Valider',
                        style: TextStyle(
                            fontSize: 18,
                        ),
                    ),
                    onPressed: () async {
                        await Api.doTask(
                            service: service, 
                            user: selectedUserController.value,
                            date: selectedDateController.value,
                            meal: selectedMealController.value);
                        await asyncCallback();
                        Navigator.of(context).pop();
                    },
                ),
            ],
            
        );
    }

    Padding buildDateSection(
        BuildContext context,
        ValueNotifier<Meal> selectedMealController,
        ValueNotifier<DateTime> selectedDateController) {
        final selectedDate = selectedDateController.value;
      return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
                children: [
                    ServiceCardActionDialogSectionTitle(title: 'Date'),
                    Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                            children: [
                                IconButton(
                                    icon: Icon(
                                        Icons.date_range_outlined,
                                        size: 32,
                                        color: Colors.blueAccent), 
                                    onPressed: () async {
                                        final _selectedDate = await showDatePicker(
                                            context: context,
                                            initialDate: selectedDate,
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime.now(),
                                            locale: Locale('fr', 'FR')
                                        );
                                        if (_selectedDate != null)
                                            selectedDateController.value = _selectedDate;
                                    }),
                                Text(
                                    DateFormat.MMMMEEEEd('fr_FR').format(selectedDate),
                                    style: TextStyle(
                                        color: Colors.grey[700]
                                    ),
                                ),
                            ],
                        ),
                    ),
                    useMeal 
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                            children: [
                                Tag(
                                    label: 'midi',
                                    isGrey: selectedMealController.value != Meal.LUNCH,
                                    color: Colors.blueAccent,
                                    onTap: () => selectedMealController.value = Meal.LUNCH,
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Tag(
                                        label: 'soir',
                                        isGrey: selectedMealController.value != Meal.DINNER,
                                        color: Colors.blueAccent,
                                        onTap: () => selectedMealController.value = Meal.DINNER,
                                    ),
                                ),
                            ],
                        ),
                    )
                    : Container(),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
            ),
        );
    }

    Column buildUserSection(ValueNotifier<User> selectedUserController) {
      return Column(
            children: [
                ServiceCardActionDialogSectionTitle(title: 'Qui ?'),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: StoreConnector<AppState, List<User>>(
                        converter: (store) => store.state.users,
                        builder: (context, users) {
                            return Wrap(
                                children: users.map((_user) => Padding(
                                    padding: const EdgeInsets.only(right: 8, bottom: 8),
                                    child: UserTag(
                                        user: _user,
                                        isGrey: selectedUserController.value.id != _user.id,
                                        onTap: () => selectedUserController.value = _user,
                                    ),
                               )).toList());
                        }
                    ),
                ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
        );
    }
}
