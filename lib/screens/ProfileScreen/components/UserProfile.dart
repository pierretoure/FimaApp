import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:FimaApp/screens/ProfileScreen/components/LogOutButton.dart';
import 'package:FimaApp/utils/Converters.dart';
import 'package:FimaApp/widgets/FimaCard/FimaCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux_hooks/flutter_redux_hooks.dart';

class UserProfile extends HookWidget {
    const UserProfile({
        Key key,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        final user = useSelector<AppState, User>((state) => state.user);
        final Color userColor = UserColorConverter.parse(user.color);
        
        return FimaCard(
            contentBuilder: (context, isOpen) => Column(
                children: [
                    Text(
                        user.name,
                        style: TextStyle(
                            color: userColor,
                            fontSize: 28
                        ),
                    ),
                    LogOutButton(),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
            ),
            contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 8),
            actionPosition: ActionPosition.left,
            actionColor: userColor.withAlpha(100),
            actionType: ActionType.indicator,
        );
    }
}
