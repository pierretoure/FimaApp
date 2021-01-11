import 'package:FimaApp/modals/Meal.dart';
import 'package:FimaApp/modals/Service.dart';
import 'package:FimaApp/modals/Task.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

const localhost = '192.168.1.27';
const apiUrl = 'http://$localhost:8080/api';

abstract class ApiSchema {
    // Users
    static Future<List<User>> Function() getUsers;

    // Services
    static List<Service> Function() getServices;
    static List<Task> Function(Service service) getTasks;
    static Future<void> Function(Service service, User user) doTask;
    static Future<void> Function(Service service) getDelegatedUser;
}

class Api implements ApiSchema {
    static getDataFromHttpResponse(Response response) {
        var json = convert.jsonDecode(response.body);
        return json['data'];
    }

    static Future<List<User>> getUsers() async {
        var url = '$apiUrl/users';
        List<User> users = [];
        var response = await http.get(url);
        if (response.statusCode == 200) {
            final data = getDataFromHttpResponse(response);
            users = data.map<User>((_user) => User.fromJson(_user)).toList();
        } else {
            print('Request failed with status: ${response.statusCode}.');
        }
        return users;
    }
    
    static List<Service> getServices() => [
        Service(
            title: 'Table',
            id: 1,
            icon: Icons.access_alarm),
        Service(
            title: 'Lave vaisselle', 
            id: 2,
            icon: Icons.account_balance),
    ];
    
    static Future<void> getTasks(Service service) async {
        List<Task> tasks;
        var url = '$apiUrl/services/${service.id}/tasks';
        var response = await http.get(url);
        if (response.statusCode == 200) {
            final data = getDataFromHttpResponse(response);
            tasks = data.map<Task>((_task) => Task.fromJson(_task)).toList();
        } else {
            print('Request failed with status: ${response.statusCode}.');
        }
        return tasks;
    }
    
    static Future<void> doTask({@required Service service, @required User user, DateTime date, Meal meal}) async {
        var url = '$apiUrl/services/${service.id}/tasks';
        var response = await http.post(url, body: {
            'user_id': user.id,
            'date': date.toIso8601String()+'Z',
            'meal': meal.toString().split('.').last
        });
        print('date: $date');
        print('date.toIso8601String(): ${date.toIso8601String()}');
        print(response.body);
        if (response.statusCode != 200) {
            print('Request failed with status: ${response.statusCode}.');
        }
    }

    static Future<User> getDelegatedUser(Service service) async {
        var url = '$apiUrl/services/${service.id}/delegatedUser';
        User user;
        var response = await http.get(url);
        if (response.statusCode == 200) {
            final data = getDataFromHttpResponse(response);
            user = User.fromJson(data);
        } else {
            print('Request failed with status: ${response.statusCode}.');
        }
        return user;
    }
}