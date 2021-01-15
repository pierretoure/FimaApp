

import 'package:flutter/material.dart';

class User {
    final String id;
    final String name;
    final String color;
    final DateTime createDate;

    const User({
        @required this.id,
        @required this.name,
        this.color,
        this.createDate
    });

    // !!!
    static User fromJson(json) => User(
        id: json['_id'] != null ? json['_id'] : 'unknow',
        name: json['name'] != null ? json['name'] : 'unknow',
        color: json['color'],
        createDate: json['createDate'] != null ? DateTime.parse(json['createDate']) : null
    );

    // !!!
    dynamic toJson() => {
        '_id': id,
        'name': name,
        'color': color,
        'createDate': createDate != null ? createDate.toString() : null
    };
}