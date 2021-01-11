import 'package:FimaApp/modals/Meal.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/utils/Convertors.dart';

class Task {
    final String id;
    final User user;
    final dynamic service;
    final DateTime date;
    final Meal meal;

    const Task({
        this.id,
        this.user,
        this.service,
        this.date,
        this.meal
    });

    // !!!
    static Task fromJson(json) => Task(
        id: json['_id'] != null ? json['_id'] : 'unknow',
        user: json['user'] != null ? User.fromJson(json['user']) : 'unknow',
        service: json['service'] != null ? json['service'] : 'unknow',
        date: json['date'] != null ? DateTime.parse(json['date']) : 'unknow',
        meal: json['meal'] != null ? MealConvertor.parse(json['meal']) : 'unknow',
    );

    // !!!
    dynamic toJson() => {
        '_id': id,
        'user': user,
        'service': service,
        'meal': meal,
        'date': date != null ? date.toString() : null
    };
}