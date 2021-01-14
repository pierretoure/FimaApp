import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/utils/Converters.dart';
import 'package:FimaApp/widgets/Tag/Tag.dart';
import 'package:flutter/material.dart';

class UserTag extends StatelessWidget {
    const UserTag({
        Key key,
        @required this.user,
        this.isGrey = false,
        this.onTap,
    }) : super(key: key);

    final User user;
    final bool isGrey;
    final void Function() onTap;

    @override
    Widget build(BuildContext context) {
        String userName = user != null 
        ? user.name ?? "unknow" 
        : 'loading...';
        String userColor = user == null || isGrey
        ? '000000'
        : UserColorConverter.parseToString(user.color) ?? '000000';
        return Tag(
            key: key,
            label: userName,
            color: Color(int.parse('0xff$userColor')),
            isGrey: isGrey,
            onTap: onTap,
        );
    }
}