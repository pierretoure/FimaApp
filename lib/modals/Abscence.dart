import 'package:FimaApp/utils/Converters.dart';
import 'package:flutter/material.dart';

import 'Meal.dart';
import 'User.dart';

class Absence {

    const Absence({
        @required this.id,
        @required this.user,
        @required this.date,
        @required this.meal
    });
    
    final String id;
    final User user;
    final DateTime date;
    final Meal meal;

    // !!!
    static Absence fromJson(json) => Absence(
        id: json['_id'] != null ? json['_id'] : 'unknow',
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        date: json['date'] != null ? DateTime.parse(json['date']) : null,
        meal: json['meal'] != null ? MealConverter.parse(json['meal']) : null,
    );

    // !!!
    dynamic toJson() => {
        '_id': id,
        'date': date != null ? date.toString() : null,
        'meal': MealConverter.parseToString(meal),
    };
}
