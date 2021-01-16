import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/screens/ProfileScreen/components/LogOutButton.dart';
import 'package:FimaApp/utils/Converters.dart';
import 'package:FimaApp/widgets/FimaCard/FimaCard.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
    const UserProfile({
        Key key,
        @required this.user,
    }) : super(key: key);

    final User user;

    @override
    Widget build(BuildContext context) {
        final Color userColor = UserColorConverter.parse(user.color);
        return FimaCard(
            contentBuilder: (context, isOpen) => Column(
                children: [
                    Text(
                        user.name,
                        style: TextStyle(
                            color: userColor,
                            fontSize: 31
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
