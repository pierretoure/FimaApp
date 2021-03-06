import 'dart:convert';

import 'package:FimaApp/modals/Abscence.dart';
import 'package:FimaApp/modals/Secrets.dart';
import 'package:FimaApp/modals/Service.dart';
import 'package:FimaApp/modals/ShoplistItem.dart';
import 'package:FimaApp/modals/Task.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utils/Converters.dart';

/// FimaApi Schema
///
/// - Users
/// Future<List<User>> getUsers();
/// Future<void> getDelegatedUserOf(Service service);
/// Future<List<Absences>> getAbsencesOf(User user);
/// Future<Absences> createAbsence(Absence absence);
/// Future<List<Absences>> createAbsences(User user, List<Absence> absences);
/// Future<void> deleteAbsence(Absence absence);
/// Future<void> deleteAbsences(User user, List<Absence> absences);
/// 
/// - Services
/// List<Service> services();
/// 
/// - Tasks
/// Future<List<Task>> getTasksOf(Service service);
/// Future<Task> createTask(Task task)
/// 
/// - Shoplist
/// Future<List<ShoplistItem>> getShoplistItems()
/// Future<ShoplistItem> createShoplistItem(ShoplistItem item)
/// Future<ShoplistItem> updateShoplistItem(ShoplistItem item)
/// Future<void> deleteShoplistItem(ShoplistItem item)
///
class FimaApi {

    FimaApi({
        this.secrets
    }) {
        fimaApiHostname = 'https://fimaapi.herokuapp.com';
        fimaApiUrl = '$fimaApiHostname/api';
        airtableApiUrl = 'https://api.airtable.com/v0/${secrets.airtableApiBaseId}';
        airtableAuthHeaders = {
            'Authorization': 'Bearer ${secrets.airtableApiKey}'
        };
    }

    final Secrets secrets;
    String fimaApiHostname;
    String fimaApiUrl;
    String airtableApiUrl;
    dynamic airtableAuthHeaders;

    // !!! Initialization
    static Future<FimaApi> initialize() async {
        final secretsFromAssets = await Secrets.fromAssets();
        return FimaApi(secrets: secretsFromAssets);
    }

    // !!!
    static FimaApi fromJson(json) => FimaApi(
        secrets: Secrets.fromJson(json['secrets'])
    );

    // !!!
    dynamic toJson() => {
        'secrets': this.secrets.toJson()
    };

    static _getDataFrom(Response response) {
        var json = convert.jsonDecode(response.body);
        return json['data'];
    }

    static _getAirtableRecordsFrom(Response response) {
        var json = convert.jsonDecode(response.body);
        return json['records'];
    }

    // !! Users

    Future<List<User>> getUsers() async {
        var url = '$fimaApiUrl/users';
        List<User> users = [];
        var response = await http.get(url, headers: {});
        if (response.statusCode == 200) {
            final data = _getDataFrom(response);
            users = data.map<User>((_user) => User.fromJson(_user)).toList();
        } else {
            print('Request failed with status: ${response.statusCode}.');
        }
        return users;
    }

    Future<User> getDelegatedUserOf(Service service) async {
        var url = '$fimaApiUrl/services/${service.id}/delegatedUser';
        User user;
        var response = await http.get(url);
        if (response.statusCode == 200) {
            final data = _getDataFrom(response);
            user = User.fromJson(data);
        } else {
            print('Request failed with status: ${response.statusCode}.');
        }
        return user;
    }

    Future<List<Absence>> getAbsencesOf(User user) async {
        var url = '$fimaApiUrl/users/${user.id}/absences';
        var response = await http.get(url);
        var absences = [];
        if (response.statusCode == 200) {
            final data = _getDataFrom(response);
            absences = data.map<Absence>((_absence) => Absence.fromJson(_absence)).toList();
        } else {
            print('Request failed with status: ${response.statusCode}.');
        }
        return absences;
    }

    Future<Absence> createAbsence(Absence absence) async {
        var url = '$fimaApiUrl/users/${absence.userId}/absences';
        var response = await http.post(url, body: {
            'date': absence.date.toIso8601String()+'Z',
            'meal': MealConverter.parseToString(absence.meal)
        });
        var newAbsence;
        if (response.statusCode == 200) {
            var data = _getDataFrom(response);
            newAbsence = Absence.fromJson(data);
        } else {
            print('Request failed with status: ${response.statusCode}.');
        }
        return newAbsence;
    }

    Future<List<Absence>> createAbsences(User user, List<Absence> absences) async {
        var url = '$fimaApiUrl/users/${user.id}/absences-collection';
        var response = await http.post(url, body: {
            'absences': jsonEncode(absences.map((_absence) => {
                'date': _absence.date.toIso8601String()+'Z',
                'meal': MealConverter.parseToString(_absence.meal)
            }).toList())
        });
        var newAbsences;
        if (response.statusCode == 200) {
            var data = _getDataFrom(response);
            newAbsences = data.map<Absence>((_absence) => Absence.fromJson(_absence)).toList();
        } else {
            print('Request failed with status: ${response.statusCode}.');
        }
        return newAbsences;
    }

    Future<void> deleteAbsence(Absence absence) async {
        var url = '$fimaApiUrl/users/${absence.userId}/absences/${absence.id}';
        var response = await http.delete(url);
        if (response.statusCode != 200) {
            print('Request failed with status: ${response.statusCode}.');
        }
    }

    Future<void> deleteAbsences(User user, List<Absence> absences) async {
        var url = '$fimaApiUrl/users/${user.id}/absences-collection?absences=["${absences.map((_absence) => _absence.id).toList().join('","')}"]';
        var urlEncoded = Uri.encodeFull(url);
        var response = await http.delete(urlEncoded);
        if (response.statusCode != 200) {
            print('Request failed with status: ${response.statusCode}.');
        }
    }

    // !! Services
    
    List<Service> services = [
        Service(
            title: 'Table',
            id: 1,
            icon: Icons.access_alarm),
        Service(
            title: 'Lave vaisselle', 
            id: 2,
            icon: Icons.account_balance),
    ];

    // !! Tasks
    
    Future<List<Task>> getTasksOf(Service service) async {
        List<Task> tasks;
        var url = '$fimaApiUrl/services/${service.id}/tasks';
        var response = await http.get(url);
        if (response.statusCode == 200) {
            final data = _getDataFrom(response);
            tasks = data.map<Task>((_task) => Task.fromJson(_task)).toList();
        } else {
            print('Request failed with status: ${response.statusCode}.');
        }
        return tasks;
    }
    
    Future<Task> createTask(Task task) async {
        var url = '$fimaApiUrl/services/${task.service.id}/tasks';
        var response = await http.post(url, body: {
            'user_id': task.user.id,
            'date': task.date.toIso8601String()+'Z',
            'meal': task.meal.toString().split('.').last
        });
        Task newTask;
        if (response.statusCode == 200) {
            final data = _getDataFrom(response);
            newTask = Task.fromJson(data);
        } else {
            print('Request failed with status: ${response.statusCode}.');
        }
        return newTask;
    }

    // !! Shoplist

    Future<List<ShoplistItem>> getShoplistItems() async {
        List<ShoplistItem> shoplistItems;
        var url = '$airtableApiUrl/courses';
        var response = await http.get(url, headers: airtableAuthHeaders);
        if (response.statusCode == 200) {
            final List records = _getAirtableRecordsFrom(response);
            shoplistItems = records.map<ShoplistItem>((_record) => ShoplistItemConverter.parseAirtableRecord(_record)).where((item) => item.product.length > 0).toList();
        } else {
            print('Request failed with status: ${response.statusCode}.');
        }
        return shoplistItems;
    }

    Future<ShoplistItem> createShoplistItem(ShoplistItem item) async {
        var url = '$airtableApiUrl/courses';
        var body = jsonEncode({
            'records': [
                {
                    "fields": {
                        "produit": item.product,
                        "utilisateur": item.username,
                        "quantité": item.quantity
                    }
                },
            ]
        });
        var response = await http.post(url, headers: {
            'Content-Type': 'application/json', 
            ...airtableAuthHeaders
        }, body: body);
        ShoplistItem createdItem;
        if (response.statusCode == 200) {
            final records = _getAirtableRecordsFrom(response);
            createdItem = ShoplistItemConverter.parseAirtableRecord(records.first);
        } else {
            print('Request failed with status: ${response.statusCode}.');
        }
        return createdItem;
    }

    Future<ShoplistItem> updateShoplistItem(ShoplistItem item) async {
        var url = '$airtableApiUrl/courses';
        var body = jsonEncode({
            'records': [
                {
                    "id": item.id,
                    "fields": {
                        "produit": item.product,
                        "utilisateur": item.username,
                        "quantité": item.quantity
                    }
                },
            ]
        });
        var response = await http.put(url, headers: {
            'Content-Type': 'application/json', 
            ...airtableAuthHeaders
        }, body: body);
        ShoplistItem updatedItem;
        if (response.statusCode == 200) {
            final records = _getAirtableRecordsFrom(response);
            updatedItem = ShoplistItemConverter.parseAirtableRecord(records.first);
        } else {
            print('Request failed with status: ${response.statusCode}.');
        }
        return updatedItem;
    }

    Future<void> deleteShoplistItem(ShoplistItem item) async {
        var url = '$airtableApiUrl/courses?records[]=${item.id}';
        var urlEncoded = Uri.encodeFull(url);
        var response = await http.delete(urlEncoded, headers: airtableAuthHeaders);
        if (response.statusCode != 200) {
            print('Request failed with status: ${response.statusCode}.');
        }
    }
}