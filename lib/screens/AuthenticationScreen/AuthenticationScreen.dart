import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:FimaApp/app.dart';
import 'package:FimaApp/screens/SelectUserScreen/SelectUserScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux_hooks/flutter_redux_hooks.dart';

class AuthenticationScreen extends HookWidget {
    @override
    Widget build(BuildContext context) {
        final user = useSelector<AppState, User>((state) => state.user);

        return Scaffold(
            body: SafeArea(
                child: user != null
                    ? FimaApp()
                    : SelectUserScreen(),
            ),
            backgroundColor: Color(0xfff5f5f5),
            resizeToAvoidBottomInset: false,
        );
    }
}
