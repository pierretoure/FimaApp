import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/redux/actions/UserActions.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class UserCard extends StatelessWidget {
    const UserCard(this.user);

    final User user;

    @override
    Widget build(BuildContext context) {
        return StoreConnector<AppState, void Function(User user)>(
            converter: (store) => (User user) => store.dispatch(SelectUserAction(user)),
            builder: (context, setUser) => InkWell(
                child: Column(
                    children: [
                        Expanded(
                            child: buildUserImage(),
                            flex: 8),
                        Container(height: 8),
                        Expanded(
                            child: buildUserName(),
                            flex: 2),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                onTap: () => setUser(user),
            ),
        );
    }

    Text buildUserName() {
        return Text(
            user.name,
            style: TextStyle(
                color: Colors.grey[600],
                letterSpacing: 1
            ),
        );
    }

    AspectRatio buildUserImage() {
        return AspectRatio(
            aspectRatio: 1,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
            ),
        );
    }
}
