import 'dart:math';

import 'package:FimaApp/Hooks/UseApi.dart';
import 'package:FimaApp/modals/Service.dart';
import 'package:FimaApp/modals/Task.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/utils/Converters.dart';
import 'package:FimaApp/widgets/FimaCard/FimaCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import 'ServiceCardDialog.dart';
import 'UserTag.dart';

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

        final delegatedUserController = useState<User>(null);
        final tasksController = useState<List<Task>>([]);

        useEffect(() {
            var isDisposed = false;
            final fetchDelegatedUserAndTasks = () async {
                final List delegatedUserAndTasks = await Future.wait([
                    getDelegatedUserOf(service),
                    getTasksOf(service)
                ]);
                if (!isDisposed) {
                    delegatedUserController.value = delegatedUserAndTasks[0];
                    tasksController.value = delegatedUserAndTasks[1];
                }
            };
            controller.onRefresh(fetchDelegatedUserAndTasks);
            fetchDelegatedUserAndTasks();
            return () {
                isDisposed = true;
            };
        }, []);

        return FimaCard(
            title: service.title,
            contentBuilder: (context, isOpen) => buildContent(isOpen, delegatedUserController),
            openContentBuilder: (context) => buildOpenContent(tasksController),
            actionIconData: Icons.done_rounded,
            onAction: () => showServiceCardActionDialog(
                context, 
                getDelegatedUserOf, 
                getTasksOf, 
                delegatedUserController, 
                tasksController),
        );
    }

    Future<void> showServiceCardActionDialog(
        BuildContext context, 
        Future<User> getDelegatedUserOf(Service service), 
        Future<List<Task>> getTasksOf(Service service), 
        ValueNotifier<User> delegatedUserController, 
        ValueNotifier<List<Task>> tasksController
    ) async {
        return showDialog<void>(
            context: context,
            builder: (context) => ServiceCardActionDialog(
                service: service, 
                asyncCallback: () async {
                    final List delegatedUserAndTasks = await Future.wait([
                        getDelegatedUserOf(service),
                        getTasksOf(service)
                    ]);
                    delegatedUserController.value = delegatedUserAndTasks[0];
                    tasksController.value = delegatedUserAndTasks[1];
                }, 
                user: delegatedUserController.value,
                useMeal: service.id == 1,
            ),
        );
    }

    Column buildOpenContent(ValueNotifier<List<Task>> tasksController) {
      return Column(
              children: tasksController.value.length > 0
              ? tasksController.value.sublist(0, min(tasksController.value.length, 6)).map((_task) {
                  String dateInfo = '${_task.date.day} ${service.id == 1 ? MealConverter.translateFR(_task.meal) : DateFormat.MMM('fr_FR').format(_task.date)}';
                  return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                          children: [
                              Container(
                                  child: Text(
                                      dateInfo,
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w600
                                      ),
                                  ),
                                  width: 62,
                              ),
                              UserTag(user: _task.user),
                          ],
                      ),
                  );
              }).toList()
              : [],
          );
    }

    Padding buildContent(bool isOpen, ValueNotifier<User> delegatedUserController) {
      return Padding(
              child: Row(
                  children: [
                      Icon(
                          isOpen 
                          ? Icons.keyboard_arrow_down_rounded 
                          : Icons.keyboard_arrow_right_rounded,
                          size: 28,
                          color: Colors.grey,
                      ),
                      Padding(
                          child: delegatedUserController.value != null 
                          ? UserTag(user: delegatedUserController.value)
                          : Text('loading...'),
                          padding: const EdgeInsets.only(left: 32.0),
                      ),
                  ],
              ),
              padding: const EdgeInsets.only(top: 8.0),
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