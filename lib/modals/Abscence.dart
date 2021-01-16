import 'package:FimaApp/utils/Converters.dart';
import 'package:flutter/material.dart';

import 'Meal.dart';
import 'User.dart';

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
}
