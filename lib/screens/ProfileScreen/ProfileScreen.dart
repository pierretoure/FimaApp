import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/redux/actions/UserActions.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:FimaApp/screens/HomeScreen/components/UserTag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux_hooks/flutter_redux_hooks.dart';

class ProfileScreen extends HookWidget {
    @override
    Widget build(BuildContext context) {
        final user = useSelector<AppState, User>((state) => state.user);
        final dispatch = useDispatch<AppState>();

        return Container(
            child: Padding(
                child: Column(
                    children: [
                        Center(
                            child: Row(
                                children: [
                                    Text(
                                        'Utilisateur : ',
                                        style: TextStyle(
                                            fontSize: 16
                                        ),
                                    ),
                                    UserTag(user: user),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                            ),
                        ),
                        OutlineButton.icon(
                            icon: Icon(Icons.logout, color: Colors.red,),
                            label: Text(
                                'se déconnecter', 
                                style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () => dispatch(LogOutAction()),
                            borderSide: BorderSide(color: Colors.red),
                            highlightedBorderColor: Colors.red,
                            highlightColor: Colors.red[50],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(32)),
                            ),
                        ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                padding: EdgeInsets.all(32),
            )
        );
    }
}