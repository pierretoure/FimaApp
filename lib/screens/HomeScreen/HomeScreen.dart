import 'package:FimaApp/Hooks/UseApi.dart';
import 'package:FimaApp/modals/Service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'components/ServiceCard.dart';

class HomeScreen extends HookWidget {
    const HomeScreen({
        Key key,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        RefreshController refreshController = RefreshController();

        final services = useApi<List<Service>>((api) => api.services);
        final serviceControllers = services.map((_service) => ServiceCardController()).toList();

        return SmartRefresher(
            child: ListView(
                children: [
                    Center(
                        child: Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: Text(
                                'Famille TOURÉ',
                                style: TextStyle(
                                    fontSize: 26,
                                    color: Colors.grey[600],
                                ),
                            ),
                        ),
                    ),
                    ...services.asMap().entries.map((entry) {
                        final index = entry.key;
                        final service = entry.value;
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ServiceCard(
                                controller: serviceControllers.elementAt(index),
                                service: service
                            ),
                        );
                    }),
                ],
                padding: EdgeInsets.fromLTRB(32, 32, 32, 0),
            ),
            controller: refreshController,
            enablePullUp: false,
            header: MaterialClassicHeader(),
            onRefresh: () async {
                await updateServices(serviceControllers);
                refreshController.refreshCompleted();
            },
        );
    }

    Future<void> updateServices(List<ServiceCardController> controllers) async {
        final refreshControllers = controllers.map<Future<void>>((_controller) => _controller.refresh());
        await Future.wait(refreshControllers);
    }
}
