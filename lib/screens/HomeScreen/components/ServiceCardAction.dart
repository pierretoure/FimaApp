import 'package:FimaApp/modals/Service.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux_hooks/flutter_redux_hooks.dart';

import 'ServiceCardActionDialog.dart';

class ServiceCardAction extends HookWidget {
    const ServiceCardAction({
        Key key,
        @required this.service,
        @required this.actualizeDelegedUser
    }) : super(key: key);

    final Service service;
    final Future<void> Function() actualizeDelegedUser;

    @override
    Widget build(BuildContext context) {
        final user = useSelector<AppState, User>((state) => state.user);
        final isPressedController = useState<bool>(false);

        return GestureDetector(
            child: Container(
                child: Center(
                    child: Icon(
                        Icons.done_rounded,
                        color: isPressedController.value 
                        ? Colors.blueAccent
                        : Colors.blueGrey[600],
                        size: 50,
                    ),
                ),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                ),
            ),
            onTap: () => showDialog(
                context: context,
                builder: (context) => ServiceCardActionDialog(
                    service: service, 
                    asyncCallback: actualizeDelegedUser, 
                    user: user,
                    useMeal: service.id == 1),
            ),
        );
    }
}
