import 'package:FimaApp/redux/actions/UserActions.dart';
import 'package:FimaApp/redux/states/AppState.dart';

AppState userReducer(AppState state, Object action) {
    if (action is SelectUserAction) {
        return state.copyWith(user: action.user);
    }
    if (action is LogOutAction) {
        return state.copyWithNullUser();
    }
    if (action is SetUsersAction) {
        return state.copyWith(users: action.users);
    }

    return state;
}