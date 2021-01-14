import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/redux/actions/UserActions.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:FimaApp/utils/Converters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux_hooks/flutter_redux_hooks.dart';

class UserCard extends HookWidget {
    const UserCard(this.user);

    final User user;

    @override
    Widget build(BuildContext context) {
        final dispatch = useDispatch<AppState>();

        return InkWell(
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
            onTap: () => dispatch(SelectUserAction(user)),
        );
    }

    Text buildUserName() {
        return Text(
            user.name,
            style: TextStyle(
                color: isUserColorValid() 
                    ? UserColorConverter.parse(user.color) 
                    : Colors.grey[600],
                letterSpacing: 1
            ),
        );
    }

    bool isUserColorValid() => user.color != null && (user.color.length == 7 || user.color.length ==6 || user.color.length == 3);

    AspectRatio buildUserImage() {
        return AspectRatio(
            aspectRatio: 1,
            child: Container(
                decoration: BoxDecoration(
                    color: isUserColorValid() 
                        ? UserColorConverter.parse(user.color).withAlpha(100) 
                        : Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
            ),
        );
    }
}
