import 'package:FimaApp/hooks/UseAbsencesController.dart';
import 'package:FimaApp/hooks/UseApi.dart';
import 'package:FimaApp/modals/Abscence.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:FimaApp/widgets/Skeleton/RoundedSkeleton.dart';
import 'package:FimaApp/widgets/FimaBottomSheet/FimaBottomSheet.dart';
import 'package:FimaApp/widgets/FimaCard/FimaCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux_hooks/flutter_redux_hooks.dart';

import 'AbsencesEditingListView.dart';

class AbsenceSection extends HookWidget {
    const AbsenceSection({
        Key key,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {

        final user = useSelector<AppState, User>((state) => state.user);
        final getAbsences = useApi<Future<List<Absence>> Function()>((api) => () => api.getAbsencesOf(user));
        
        final createAbsences = useApi<Future<List<Absence>> Function(List<Absence>)>
            ((api) => (absences) => api.createAbsences(user, absences));
        final deleteAbsences = useApi<Future<void> Function(List<Absence>)>
            ((api) => (absences) => api.deleteAbsences(user, absences));

        final absencesEditingController = useAbsencesEditingController.fromValue(
            AbsencesEditingValue(
                absences: [],
                createAbsences: createAbsences,
                deleteAbsences: deleteAbsences));

        final isLoadingController = useState<bool>(true);

        useEffect(() {
            bool isDisposed = false;
            final fetchAbsences = () async {
                final _absences = await getAbsences();
                if (!isDisposed) {
                    absencesEditingController.absences = [..._absences];
                    isLoadingController.value = false;
                }
            };
            fetchAbsences();
            return () => isDisposed = true;
        }, []);

        final update = useValueListenable<AbsencesEditingValue>(absencesEditingController);

        useEffect(() {
            absencesEditingController.value = update;
            return null;
        }, [update]);

        return FimaCard(
            title: 'Absences', 
            contentBuilder: (context, isOpen) => isLoadingController.value 
                ? buildLoadingIndicator()
                : buildContent(absencesEditingController),
            actionIconData: Icons.date_range_rounded,
            onAction: () async {
                await showModalBottomSheet(
                    context: context,
                    builder: (context) => FimaBottomSheet(
                        title: 'Absences',
                        content: Container(
                            child: AbsencesEditingListView(controller: absencesEditingController),
                            decoration: BoxDecoration(
                                border: Border.symmetric(
                                    horizontal: BorderSide(
                                        width: 1,
                                        color: Colors.grey[300],
                                    ),
                                ),
                            ),
                            height: 140,
                        ),
                        validButtonTitle: 'Sauvegarder',
                        onValidButtonPressedAsync: () async {
                            await absencesEditingController.save();
                        },
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
                );
                // Clear editions on BottomSheet close
                absencesEditingController.clearEditions();
            },
        );
    }

    Widget buildLoadingIndicator() {
        return Padding(
            child: RoundedSkeleton(
                height: 16,
                width: 80,
            ),
            padding: EdgeInsets.only(top: 16),
        );
    }

    Widget buildContent(AbsencesEditingController controller) {
        final absencesCount = controller.absences.length;
        return Padding(
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
                            text: '$absencesCount définie${absencesCount > 1 ? 's' : ''}',
                            style: TextStyle(
                                fontWeight: FontWeight.normal
                            ),
                        )
                    ]
                ),
            ),
            padding: const EdgeInsets.only(top: 16),
        );
    }

    Future<void> saveModifications() async {
        return Future.delayed(Duration(milliseconds: 500), 
            () => print('saved'));
    }
}
