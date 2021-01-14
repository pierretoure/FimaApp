import 'package:FimaApp/Hooks/UseApi.dart';
import 'package:FimaApp/modals/Service.dart';
import 'package:FimaApp/modals/User.dart';
import 'package:FimaApp/redux/states/AppState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux_hooks/flutter_redux_hooks.dart';

import 'components/ServiceCard.dart';

class HomeScreen extends HookWidget {
    const HomeScreen({
        Key key,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        // final services = useApi<List<Service>>((api) => api.services);
        final services = useApi<List<Service>>((api) => api.services);
        return Container(
            child: Center(
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
                        ...services.map((_service) => 
                            Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: ServiceCard(service: _service),
                            )),
                    ],
                ),
            ),
            padding: EdgeInsets.fromLTRB(32, 32, 32, 0),
        );
    }
}
