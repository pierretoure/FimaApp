import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/redux/actions/UserActions.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:FimaApp/screens/HomeScreen/components/UserTag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProfileScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Container(
            child: Padding(
                child: Column(
                    children: [
                        StoreConnector<AppState, User>(
                            converter: (store) => store.state.user,
                            builder: (context, user) => Center(
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
                        ),
                        StoreConnector<AppState, VoidCallback>(
                            converter: (store) => () => store.dispatch(LogOutAction()),
                            builder: (context, logOut) => OutlineButton.icon(
                                icon: Icon(Icons.logout, color: Colors.red,),
                                label: Text(
                                    'se déconnecter', 
                                    style: TextStyle(color: Colors.red),
                                ),
                                onPressed: logOut,
                                borderSide: BorderSide(color: Colors.red),
                                highlightedBorderColor: Colors.red,
                                highlightColor: Colors.red[50],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(32)),
                                ),
                            ),
                        )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                padding: EdgeInsets.all(32),
            )
        );
    }
}