import 'package:FimaApp/utils/Api.dart';
import 'package:flutter/material.dart';

import 'components/ServiceCard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    ...Api.getServices().map((_service) => 
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
