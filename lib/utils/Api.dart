import 'dart:convert';

import 'package:FimaApp/modals/Secrets.dart';
import 'package:FimaApp/modals/Service.dart';
import 'package:FimaApp/modals/ShoplistItem.dart';
import 'package:FimaApp/modals/Task.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'Converters.dart';

/// FimaApi Schema
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
/// static Future<List<ShoplistItem>> getShoplistItems()
/// static Future<ShoplistItem> createShoplistItem(ShoplistItem item)
/// static Future<ShoplistItem> updateShoplistItem(ShoplistItem item)
/// static Future<void> deleteShoplistItem(ShoplistItem item)
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
    
    Future<void> createTask(Task task) async {
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