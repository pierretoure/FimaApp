

import 'dart:convert';

import 'package:FimaApp/modals/User.dart';

class AppState {
    final User user;
    final List<User> users;

    AppState({
        this.user,
        this.users
    });

    static AppState initialState({
        User user,
        final List<User> users
    }) => AppState(
        user: user ?? null,
        users: users ?? []);

    AppState copyWith({
        User user,
        final List<User> users
    }) => AppState(
        user: user ?? this.user,
        users: users ?? this.users);

    AppState copyWithNullUser() => AppState(
        user: null,
        users: this.users);

    // !!!
    static AppState fromJson(dynamic json) {
        if (json == null) return AppState.initialState();
        return AppState(
            user: json['user'] != null ? User.fromJson(json["user"]) : null,
            users: json['users'] != null ? jsonDecode(json['users']).map<User>((_user) => User.fromJson(_user)).toList() : []);
    }

    // !!!
    dynamic toJson() => {
        'user': user != null ? user.toJson() : null,
        'users': jsonEncode(users, toEncodable: (_user) => (_user as User).toJson())};
}