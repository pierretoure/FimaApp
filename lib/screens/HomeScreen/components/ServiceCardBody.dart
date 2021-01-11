import 'dart:math';

import 'package:FimaApp/modals/Service.dart';
import 'package:FimaApp/modals/Task.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/utils/Convertors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import 'UserTag.dart';

class ServiceCardBody extends HookWidget {
    const ServiceCardBody({
        Key key,
        @required this.service,
        @required this.delegatedUser,
        @required this.tasks,
    }) : super(key: key);

    final Service service;
    final User delegatedUser;
    final List<Task> tasks;

    @override
    Widget build(BuildContext context) {
        final isOpenController = useState<bool>(false);
        return GestureDetector(
            child: Container(
                child: Column(
                    children: [
                        Text(
                            service.title,
                            style: TextStyle(
                                fontSize: 21,
                                color: Colors.grey[600],
                            ),
                        ),
                        buildDelegatedUser(isOpenController.value, delegatedUser),
                        isOpenController.value
                        ? buildTaskHistory(tasks)
                        : Container()
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                ),
                height: isOpenController.value ? null : 100,
                color: Colors.transparent,
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
            ),
            onTap: () => isOpenController.value = !isOpenController.value,
        );
    }

    Column buildTaskHistory(List<Task> tasks) {
        return Column(
            children: tasks.length > 0
            ? tasks.sublist(0, min(tasks.length, 6)).map((_task) {
                String dateInfo = '${_task.date.day} ${service.id == 1 ? MealConvertor.translateFR(_task.meal) : DateFormat.MMM('fr_FR').format(_task.date)}';
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

    Padding buildDelegatedUser(bool isOpen, User delegatedUser) {
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
                        child: delegatedUser != null 
                        ? UserTag(user: delegatedUser)
                        : Text('loading...'),
                        padding: const EdgeInsets.only(left: 32.0),
                    ),
                ],
            ),
            padding: const EdgeInsets.only(top: 8.0),
        );
    }
}
