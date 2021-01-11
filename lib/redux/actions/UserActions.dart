import 'package:FimaApp/modals/User.dart';

class SelectUserAction {
    final User user;

    SelectUserAction(this.user);
}

class LogOutAction {}

class SetUsersAction {
    final List<User> users;

    SetUsersAction(this.users);
}