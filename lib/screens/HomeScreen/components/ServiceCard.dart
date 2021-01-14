import 'package:FimaApp/Hooks/UseApi.dart';
import 'package:FimaApp/modals/Service.dart';
import 'package:FimaApp/modals/Task.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'ServiceCardAction.dart';
import 'ServiceCardBody.dart';

class ServiceCard extends HookWidget {
    final Service service;
    const ServiceCard({
        Key key,
        @required this.controller,
        @required this.service,
    }) : super(key: key);

    final ServiceCardController controller;

    @override
    Widget build(BuildContext context) {
        final getDelegatedUserOf = useApi<Future<User> Function(Service)>((api) => 
            (service) => api.getDelegatedUserOf(service));
        final getTasksOf = useApi<Future<List<Task>> Function(Service)>((api) => 
            (service) => api.getTasksOf(service));

        final delegatedUser = useState<User>(null);
        final tasks = useState<List<Task>>([]);

        useEffect(() {
            var isDisposed = false;
            final fetchDelegatedUserAndTasks = () async {
                final List delegatedUserAndTasks = await Future.wait([
                    getDelegatedUserOf(service),
                    getTasksOf(service)
                ]);
                if (!isDisposed) {
                    final _ = await getDelegatedUserOf(service);
                    print(_.name);
                    delegatedUser.value = delegatedUserAndTasks[0];
                    tasks.value = delegatedUserAndTasks[1];
                }
            };
            controller.onRefresh(() => fetchDelegatedUserAndTasks());
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
                                        getDelegatedUserOf(service),
                                        getTasksOf(service)
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

class ServiceCardController {
    AsyncCallback refresh;

    ServiceCardController() {
        refresh = () async {
            throw('Error: refresh not defined for ServiceCardController');
        };
    }

    // ! Must be set at least once
    void onRefresh(Future<void> Function() _refresh) {
        if (_refresh != null) {
            refresh = () async {
                await _refresh();
            };
        }
    }

    void dispose() {
        refresh = null;
    }
}