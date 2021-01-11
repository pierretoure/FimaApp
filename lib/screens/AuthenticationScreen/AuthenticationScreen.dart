import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:FimaApp/app.dart';
import 'package:FimaApp/screens/SelectUserScreen/SelectUserScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AuthenticationScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: SafeArea(
                child: StoreConnector<AppState, User>(
                    converter: (store) => store.state.user,
                    builder: (BuildContext context, User user) => user != null
                        ? FimaApp()
                        : SelectUserScreen(),
                ),
            ),
        );
    }
}
