

import 'dart:convert';

import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/utils/Api.dart';

class AppState {
    final User user;
    final List<User> users;
    final FimaApi api;

    AppState({
        this.user,
        this.users,
        this.api,
    });

    static AppState initialState({
        User user,
        List<User> users,
        FimaApi api,
    }) => AppState(
        user: user ?? null,
        users: users ?? [],
        api: api ?? null);

    Future<AppState> initializeApi() async {
        final api = await FimaApi.initialize();
        return this.copyWith(api: api);
    }

    AppState copyWith({
        User user,
        List<User> users,
        FimaApi api,
    }) => AppState(
        user: user ?? this.user,
        users: users ?? this.users,
        api: api ?? this.api);

    AppState copyWithNullUser() => AppState(
        user: null,
        users: this.users,
        api: this.api);

    // !!!
    static AppState fromJson(dynamic json) {
        final initialState = AppState.initialState();
        if (json == null) return initialState;
        return AppState.initialState(
            user: json['user'] != null ? User.fromJson(json["user"]) : initialState.user,
            users: json['users'] != null ? jsonDecode(json['users']).map<User>((_user) => User.fromJson(_user)).toList() : initialState.users,
            api: json['api'] != null ? FimaApi.fromJson(json['api']) : initialState.api);
    }

    // !!!
    dynamic toJson() => {
        'user': user != null ? user.toJson() : null,
        'users': jsonEncode(users, toEncodable: (_user) => (_user as User).toJson()),
        'api': api != null ? api.toJson() : null};
}