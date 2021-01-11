import 'package:FimaApp/modals/Meal.dart';
import 'package:FimaApp/modals/Service.dart';
import 'package:FimaApp/modals/Task.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiSchema {
    // Users
    static Future<List<User>> Function() getUsers;

    // Services
    static List<Service> Function() getServices;
    static List<Task> Function(Service service) getTasks;
    static Future<void> Function(Service service, User user) doTask;
    static Future<void> Function(Service service) getDelegatedUser;
}

/// Api schema
///
/// - Users
/// static Future<List<User>> getUsers();
/// static Future<void> getDelegatedUserOf(Service service);
/// 
/// - Services
/// static List<Service> services();
/// 
/// - Tasks
/// static Future<List<Task>> getTasksOf(Service service);
/// static Future<Task> createTask(Task task)
/// 
/// - Shoplist
/// static Future<List<ShopItem>> getShoplistItems()
///

const localhost = '192.168.1.27';
const fimaApiUrl = 'http://$localhost:8080/api';

const airtableApiUrl = 'https://api.airtable.com/v0/appzoC47IZLQGiNem';

class FimaApi {
    static getDataFrom(Response response) {
        var json = convert.jsonDecode(response.body);
        return json['data'];
    }

    final airtableAuthHeaders = [];

    // Users

    static Future<List<User>> getUsers() async {
        var url = '$fimaApiUrl/users';
        List<User> users = [];
        var response = await http.get(url);
        if (response.statusCode == 200) {
            final data = getDataFrom(response);
            users = data.map<User>((_user) => User.fromJson(_user)).toList();
        } else {
            print('Request failed with status: ${response.statusCode}.');
        }
        return users;
    }

    static Future<User> getDelegatedUserOf(Service service) async {
        var url = '$fimaApiUrl/services/${service.id}/delegatedUser';
        User user;
        var response = await http.get(url);
        if (response.statusCode == 200) {
            final data = getDataFrom(response);
            user = User.fromJson(data);
        } else {
            print('Request failed with status: ${response.statusCode}.');
        }
        return user;
    }

    // Services
    
    static List<Service> services = [
        Service(
            title: 'Table',
            id: 1,
            icon: Icons.access_alarm),
        Service(
            title: 'Lave vaisselle', 
            id: 2,
            icon: Icons.account_balance),
    ];

    // Tasks
    
    static Future<List<Task>> getTasksOf(Service service) async {
        List<Task> tasks;
        var url = '$fimaApiUrl/services/${service.id}/tasks';
        var response = await http.get(url);
        if (response.statusCode == 200) {
            final data = getDataFrom(response);
            tasks = data.map<Task>((_task) => Task.fromJson(_task)).toList();
        } else {
            print('Request failed with status: ${response.statusCode}.');
        }
        return tasks;
    }
    
    static Future<void> createTask(Task task) async {
        var url = '$fimaApiUrl/services/${task.service.id}/tasks';
        var response = await http.post(url, body: {
            'user_id': task.user.id,
            'date': task.date.toIso8601String()+'Z',
            'meal': task.meal.toString().split('.').last
        });
        if (response.statusCode != 200) {
            print('Request failed with status: ${response.statusCode}.');
        }
    }
}