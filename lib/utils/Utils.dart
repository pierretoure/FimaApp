import 'dart:math';

import 'package:FimaApp/modals/Meal.dart';
import 'package:FimaApp/modals/Task.dart';

class TaskUtils {
    static List<Task> getTasksSortedByHistory(List<Task> tasks) {
        final newTasks = tasks;
        newTasks.sort((a, b) {
            if (DateUtils.isSameDay(a.date, b.date))
                return a.meal == Meal.LUNCH
                    ? -1
                    : 1;
            return b.date.compareTo(a.date);
        });
        return newTasks;
    }
}

class DateUtils {
    static isSameDay(DateTime a, DateTime b) =>
        a.year == b.year
        && a.month == b.month
        && a.day == b.day;
}

class MathUtils {
    static amplifiedSine({
        int min = 0, 
        int max = 255
    }) => 
        (double x, double t0) => 
            ((((sin(x + t0) + 1) / 2) * (max - min)) + min).floor();
}
