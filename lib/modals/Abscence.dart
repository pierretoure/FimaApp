import 'package:FimaApp/utils/Converters.dart';
import 'package:FimaApp/utils/Utils.dart';
import 'package:flutter/material.dart';

import 'Meal.dart';

class Absence {

    const Absence({
        @required this.date,
        @required this.meal,
        this.id,
        this.userId,
    });
    
    final String id;
    final String userId;
    final DateTime date;
    final Meal meal;

    // !!!
    static Absence fromJson(json) => Absence(
        id: json['_id'] != null ? json['_id'] : 'unknow',
        userId: json['user'],
        date: json['date'] != null ? DateTime.parse(json['date']) : null,
        meal: json['meal'] != null ? MealConverter.parse(json['meal']) : null,
    );

    // !!!
    dynamic toJson() => {
        '_id': id,
        'user': userId,
        'date': date != null ? date.toString() : null,
        'meal': MealConverter.parseToString(meal),
    };

    // !!!
    @override
    bool operator ==(Object other) {
        if (identical(this, other))
            return true;
        return other is Absence
            && other.id == id
            && other.userId == userId
            && DateUtils.isSameDay(other.date, date)
            && other.meal == meal;
    }

    // compare both absences date and meal.
    // return true if equals.
    //
    // consider using equality operator == to
    // compare also id and userId 
    bool equals(Absence other) =>
        DateUtils.isSameDay(other.date, date)
        && other.meal == meal;

    // !!!
    @override
    int get hashCode => hashValues(
        id.hashCode,
        userId.hashCode,
        date.hashCode,
        meal.hashCode,
  );
}
