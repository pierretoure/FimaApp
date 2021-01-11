import 'package:flutter/material.dart';

import 'Meal.dart';

class Absence {
    final DateTime date;
    final Meal meal;
    const Absence({
        @required this.date,
        @required this.meal
    });
}
