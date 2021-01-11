import 'package:FimaApp/modals/Service.dart';
import 'package:FimaApp/modals/Task.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/utils/Api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'ServiceCardAction.dart';
import 'ServiceCardBody.dart';

class ServiceCard extends HookWidget {
    final Service service;
    const ServiceCard({
        Key key,
        @required this.service
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        final delegatedUser = useState<User>(null);
        final tasks = useState<List<Task>>([]);

        useEffect(() {
            var isDisposed = false;
            final fetchDelegatedUserAndTasks = () async {
                final List delegatedUserAndTasks = await Future.wait([
                    Api.getDelegatedUser(service),
                    Api.getTasks(service)
                ]);
                if (!isDisposed) {
                    delegatedUser.value = delegatedUserAndTasks[0];
                    tasks.value = delegatedUserAndTasks[1];
                }
            };
            fetchDelegatedUserAndTasks();
            return () {
                isDisposed = true;
            };
        }, []);

        return ConstrainedBox(
            child: Container(
                child: Stack(
                    children: [
                        ServiceCardBody(
                            service: service, 
                            delegatedUser: delegatedUser.value, tasks: 
                            tasks.value),
                        Positioned(
                            child: ServiceCardAction(
                                service: service,
                                actualizeDelegedUser: () async { 
                                    final List delegatedUserAndTasks = await Future.wait([
                                        Api.getDelegatedUser(service),
                                        Api.getTasks(service)
                                    ]);
                                    delegatedUser.value = delegatedUserAndTasks[0];
                                    tasks.value = delegatedUserAndTasks[1];
                                },
                            ),
                            right: 0,
                        ),
                    ],
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                    color: Colors.grey[200],
                ),
            ),
            constraints: BoxConstraints(
                minHeight: 100,
                minWidth: double.infinity
            ),
        );
    }
}
