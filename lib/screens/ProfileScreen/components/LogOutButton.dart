import 'package:FimaApp/redux/actions/UserActions.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux_hooks/flutter_redux_hooks.dart';

class LogOutButton extends HookWidget {
    const LogOutButton({
        Key key,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        final dispatch = useDispatch<AppState>();
        Color color = Colors.blueAccent;
        
        return OutlineButton.icon(
            icon: Icon(Icons.cached_rounded, color: color),
            label: Text(
                'changer de profil', 
                style: TextStyle(color: color),
            ),
            onPressed: () => dispatch(LogOutAction()),
            borderSide: BorderSide(color: color),
            highlightedBorderColor: color,
            highlightColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32)),
            ),
        );
    }
}
