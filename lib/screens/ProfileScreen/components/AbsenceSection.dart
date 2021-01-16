import 'package:FimaApp/hooks/UseApi.dart';
import 'package:FimaApp/modals/Abscence.dart';
import 'package:FimaApp/modals/Meal.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/widgets/FimaCard/FimaCard.dart';
import 'package:FimaApp/widgets/FimaDialog/FimaDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AbsenceSection extends HookWidget {
    const AbsenceSection({
        Key key,
        @required this.user,
    }) : super(key: key);

    final User user;

    @override
    Widget build(BuildContext context) {
        final absencesController = useState<List<Absence>>([]);
        final getAbsences = useApi<Future<List<Absence>> Function()>
            ((api) => () => api.getAbsencesOf(user));
        final createAbsence = useApi<Future<Absence> Function(Absence)>
            ((api) => (absence) => api.createAbsence(absence));
        final deleteAbsence = useApi<Future<void> Function(Absence)>
            ((api) => (absence) => api.deleteAbsence(absence));

        useEffect(() {
            bool isDisposed = false;
            var fetchAbsences = () async {
                final absences = await getAbsences();
                if (absences != null && !isDisposed) absencesController.value = absences;
            };
            fetchAbsences();
            return () => isDisposed = true;
        }, []);

        return FimaCard(
            title: 'Absences', 
            contentBuilder: (context, isOpen) => Padding(
                child: RichText(
                    text: TextSpan(
                        // text: absencesController.value.length.toString(),
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w700
                        ),
                        children: [
                            TextSpan(
                                text: 'à venir...',// ' définie${absencesController.value.length > 1 ? 's' : ''}',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal
                                ),
                            )
                        ]
                    ),
                ),
                padding: const EdgeInsets.only(top: 16),
            ),
            actionIconData: Icons.date_range_rounded,
            actionPosition: ActionPosition.right,
            // onAction: () => smartCreateAbsence(createAbsence, Absence(date: DateTime.now(), meal: Meal.DINNER, userId: user.id), absencesController),
            // onTap: () => smartDeleteAbsence(deleteAbsence, absencesController.value.first, absencesController),
        );
    }

    Future<void> smartCreateAbsence(
        Future<Absence> Function(Absence) createAbsence, 
        Absence absence,
        ValueNotifier<List<Absence>> absencesController,
    ) async {
        final newAbsence = await createAbsence(absence);
        absencesController.value = [...absencesController.value, newAbsence];
    }

    Future<void> smartDeleteAbsence(
        Future<void> Function(Absence) deleteAbsence, 
        Absence absence,
        ValueNotifier<List<Absence>> absencesController
    ) async {
        await deleteAbsence(absence);
        absencesController.value = absencesController.value.sublist(1);
    }
}
