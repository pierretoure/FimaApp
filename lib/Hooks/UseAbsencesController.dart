import 'package:FimaApp/modals/Abscence.dart';
import 'package:FimaApp/modals/Meal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


/// The current absences, absencesToBeCreated, and absencesToBeDeleted 
/// state for editing a run of text.
@immutable
class AbsencesEditingValue {
    /// Creates information for editing a run of text.
    ///
    /// The selection and composing range must be within the text.
    ///
    /// The [absences] and [editedAbsences] 
    /// arguments must not be null but each have default values.
    const AbsencesEditingValue({
        this.absences = const [],
        this.editedAbsences = const [],
        this.createAbsences,
        this.deleteAbsences,
    }) : assert(absences != null),
        assert(editedAbsences != null);

    final List<Absence> absences;
    final List<Absence> editedAbsences;
    final Future<List<Absence>> Function(List<Absence>) createAbsences;
    final Future<void> Function(List<Absence>) deleteAbsences;

    /// A value that corresponds to the empty string with no selection and no composing range.
    static const AbsencesEditingValue empty = AbsencesEditingValue();

    /// Creates a copy of this value but with the given fields replaced with the new values.
    AbsencesEditingValue copyWith({
        List<Absence> absences,
        List<Absence> editedAbsences,
        Future<List<Absence>> Function(List<Absence>) createAbsences,
        Future<void> Function(List<Absence>) deleteAbsences,
    }) => AbsencesEditingValue(
        absences: absences ?? this.absences,
        editedAbsences: editedAbsences ?? this.editedAbsences,
        createAbsences: createAbsences ?? this.createAbsences,
        deleteAbsences: deleteAbsences ?? this.deleteAbsences,
    );

    /// check id the absence based on date and meal
    /// is **present and not deleted** or **created** 
    bool isAbsent(DateTime date, Meal meal) {
        var absence = Absence(date: date, meal: meal);
        bool isInDatabase = absences.any((_absenceFromDB) => absence.equals(_absenceFromDB));
        bool isInEdited = editedAbsences.any((_edited) => absence.equals(_edited));
        return (isInDatabase && !isInEdited) || (!isInDatabase && isInEdited);
    }

    @override
    bool operator ==(Object other) {
        if (identical(this, other)) {
            return true;
        }
        // TODO: add deep comparison in addition to editedAbsences length
        return other is AbsencesEditingValue
            && other.editedAbsences.length == editedAbsences.length
            && other.absences.length == absences.length;
    }

    @override
    int get hashCode => hashValues(
        absences.hashCode,
        editedAbsences.hashCode,
        createAbsences.hashCode,
        deleteAbsences.hashCode,
  );
}


class AbsencesEditingController extends ValueNotifier<AbsencesEditingValue> {
    /// Creates a controller for an editable text field.
    ///
    /// This constructor treats a null [absences] argument as if it were the empty
    /// List.
    AbsencesEditingController({ List<Absence> absences })
        : super(absences == null ? AbsencesEditingValue.empty : AbsencesEditingValue(absences: absences));

    /// Creates a controller for an editable text field from an initial [AbsencesEditingValue].
    ///
    /// This constructor treats a null [value] argument as if it were
    /// [AbsencesEditingValue.empty].
    AbsencesEditingController.fromValue(AbsencesEditingValue value)
        : super(value ?? AbsencesEditingValue.empty);

    /// The current absences.
    List<Absence> get absences => value.absences;

    /// The current edited absences.
    List<Absence> get editedAbsences => value.editedAbsences;
    
    /// The function called to create absences in database.
    Future<List<Absence>> Function(List<Absence>) get createAbsences => value.createAbsences;
    
    /// The function called to delete absences in database.
    Future<void> Function(List<Absence>) get deleteAbsences => value.deleteAbsences;


    /// Setting this will notify all the listeners of this [AbsencesEditingController]
    /// that they need to update (it calls [notifyListeners]). For this reason,
    /// this value should only be set between frames, e.g. in response to user
    /// actions, not during the build, layout, or paint phases.
    ///
    /// This property can be set from a listener added to this
    /// [AbsencesEditingController]; however, one should not also set [absences]
    /// in a separate statement. To change both the [absences] and the 
    /// [editedAbsences] change the controller's [value].
    set absences(List<Absence> _absences) {
        value = value.copyWith(absences: _absences);
    }
        
    /// Setting this will notify all the listeners of this [AbsencesEditingController]
    /// that they need to update (it calls [notifyListeners]). For this reason,
    /// this value should only be set between frames, e.g. in response to user
    /// actions, not during the build, layout, or paint phases.
    ///
    /// This property can be set from a listener added to this
    /// [AbsencesEditingController]; however, one should not also set [absences]
    /// in a separate statement. To change both the [absences] and the 
    /// [editedAbsences] change the controller's [value].
    set editedAbsences(List<Absence> _absences) =>
        value = value.copyWith(editedAbsences: _absences);
        
    /// Setting this will notify all the listeners of this [AbsencesEditingController]
    /// that they need to update (it calls [notifyListeners]). For this reason,
    /// this value should only be set between frames, e.g. in response to user
    /// actions, not during the build, layout, or paint phases.
    ///
    /// This property can be set from a listener added to this
    /// [AbsencesEditingController]; however, one should not also set [absences]
    /// in a separate statement. To change both the [absences] and the 
    /// [absencesToBeCreated] change the controller's [value].
    set onCreateAbsences(Future<List<Absence>> Function(List<Absence>) _createAbsences) =>
        value = value.copyWith(createAbsences: _createAbsences);
        
    /// Setting this will notify all the listeners of this [AbsencesEditingController]
    /// that they need to update (it calls [notifyListeners]). For this reason,
    /// this value should only be set between frames, e.g. in response to user
    /// actions, not during the build, layout, or paint phases.
    ///
    /// This property can be set from a listener added to this
    /// [AbsencesEditingController]; however, one should not also set [absences]
    /// in a separate statement. To change both the [absences] and the 
    /// [absencesToBeCreated] change the controller's [value].
    set onDeleteAbsences(Future<void> Function(List<Absence>) _deleteAbsences) =>
        value = value.copyWith(deleteAbsences: _deleteAbsences);

    @override
    set value(AbsencesEditingValue newValue) {
        super.value = newValue;
    }

    /// toggle absence based on date and meal
    void toggleAbsence(DateTime date, Meal meal) {
        var absenceToToggle = Absence(date: date, meal: meal);
        bool absenceToToggleInEdited = editedAbsences.any((_edited) => absenceToToggle.equals(_edited));
        if (absenceToToggleInEdited) {
            editedAbsences = editedAbsences.length > 1
                ? editedAbsences
                    .where((_edited) => !absenceToToggle.equals(_edited)).toList()
                : [];
        } else editedAbsences = [...editedAbsences, absenceToToggle];
    }

    /// save absences editions in database by calling
    /// createAbsences() for new absences and
    /// deleteAbsences() for deleted ones.
    /// 
    /// absences is updated by adding new absences
    /// and removing deleted ones.
    Future<void> save() async {
        assert(deleteAbsences != null, "deleteAbsences can't be null");
        assert(createAbsences != null, "createAbsences can't be null");

        List<Absence> absencesToCreate = [];
        List<Absence> absencesToDelete = [];

        var absencesCopy = absences;
        
        // get absences to created and delete from edited absence
        // by comparing to existing ones in database
        editedAbsences.forEach((_edited) {
            // find edited absence in absences from db
            // if it is found, return the index
            // else, return -1
            var index = absencesCopy.indexWhere((_absence) => _edited.equals(_absence));

            if (index != -1) {
                // assume absence has to be deleted, and remove it
                // to keep O(log(n)) complexity
                absencesToDelete.add(absencesCopy.removeAt(index));
            } else {
                // assume absence has to be created
                absencesToCreate.add(_edited);
            }
        });

        // delete absences that no longer exists
        await deleteAbsences(absencesToDelete);

        // create absences that does not exists
        final newAbsences = await createAbsences(absencesToCreate);

        // set absences by join on absencesCopy (without previously 
        // deleted ones) and new ones
        this.absences = [...absencesCopy, ...newAbsences];
    }

    /// Set the [value] to empty.
    ///
    /// After calling this function, [absences] [absencesToBeCreated] 
    /// [absencesToBeDeleted] will be empty arrays.
    ///
    /// Calling this will notify all the listeners of this [AbsencesEditingController]
    /// that they need to update (it calls [notifyListeners]). For this reason,
    /// this method should only be called between frames, e.g. in response to user
    /// actions, not during the build, layout, or paint phases.
    void clear() {
        value = AbsencesEditingValue.empty;
    }

    /// Set user editions to empty.
    ///
    /// After calling this function, [absencesToBeCreated] and
    /// [absencesToBeDeleted] will be empty arrays.
    ///
    /// Calling this will notify all the listeners of this [AbsencesEditingController]
    /// that they need to update (it calls [notifyListeners]). For this reason,
    /// this method should only be called between frames, e.g. in response to user
    /// actions, not during the build, layout, or paint phases.
    void clearEditions() {
        value = value.copyWith(
            editedAbsences: []
        );
    }
}


class _AbsencesEditingControllerHookCreator {
    const _AbsencesEditingControllerHookCreator();

    /// Creates a [AbsencesEditingController] that will be disposed automatically.
    ///
    /// The [absences] parameter can be used to set the initial value of the
    /// controller.
    AbsencesEditingController call({List<Absence> absences, List<Object> keys}) {
        return use(_AbsencesEditingControllerHook(absences, keys));
    }

    /// Creates a [AbsencesEditingController] from the initial [value] that will
    /// be disposed automatically.
    AbsencesEditingController fromValue(AbsencesEditingValue value, [List<Object> keys]) {
        return use(_AbsencesEditingControllerHook.fromValue(value, keys));
    }
}

/// Creates a [AbsencesEditingController], either via initial absences or an initial
/// [AbsencesEditingValue].
///
/// To use a [AbsencesEditingController] with optional initial absences, use
/// ```dart
/// final controller = useAbsencesEditingController(absences: [
///   Absence(date: DateTime.now(), meal: Meal.LUNCH),
///   Absence(date: DateTime.now(), meal: Meal.DINNER),
/// ]);
/// ```
///
/// To use a [AbsencesEditingController] with an optional inital value, use
/// ```dart
/// final controller = useAbsencesEditingController
///   .fromValue(AbsencesEditingValue.empty);
/// ```
///
/// Changing the absences or initial value after the widget has been built has no
/// effect whatsoever. To update the value in a callback, for instance after a
/// button was pressed, use the [AbsencesEditingController.absences] or
/// [AbsencesEditingController.absences] setters. To have the [AbsencesEditingController]
/// reflect changing values, you can use [useEffect]. This example will update
/// the [AbsencesEditingController.absences] whenever a provided [ValueListenable]
/// changes:
/// ```dart
/// final controller = useAbsencesEditingController();
/// final update = useValueListenable(myAbsencesControllerUpdates);
///
/// useEffect(() {
///   controller.absences = update;
///   return null; // we don't need to have a special dispose logic
/// }, [update]);
/// ```
///
/// See also:
/// - [AbsencesEditingController], which this hook creates.
const useAbsencesEditingController = _AbsencesEditingControllerHookCreator();

class _AbsencesEditingControllerHook extends Hook<AbsencesEditingController> {
    const _AbsencesEditingControllerHook(
        this.initialAbsences, [
        List<Object> keys,
    ])  : initialValue = null,
            super(keys: keys);

    const _AbsencesEditingControllerHook.fromValue(
        this.initialValue, [
        List<Object> keys,
    ])  : initialAbsences = null,
            assert(initialValue != null, "initialValue can't be null"),
            super(keys: keys);

    final List<Absence> initialAbsences;
    final AbsencesEditingValue initialValue;

    @override
    _AbsencesEditingControllerHookState createState() {
        return _AbsencesEditingControllerHookState();
    }
}

class _AbsencesEditingControllerHookState
    extends HookState<AbsencesEditingController, _AbsencesEditingControllerHook> {

    AbsencesEditingController _controller;

    @override
    void initHook() {
        if (hook.initialValue != null) {
        _controller = AbsencesEditingController.fromValue(hook.initialValue);
        } else {
        _controller = AbsencesEditingController(absences: hook.initialAbsences);
        }
    }

    @override
    AbsencesEditingController build(BuildContext context) => _controller;

    @override
    void dispose() => _controller?.dispose();

    @override
    String get debugLabel => 'useAbsencesEditingController';
}
