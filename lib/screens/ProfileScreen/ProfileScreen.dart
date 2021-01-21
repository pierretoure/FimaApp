import 'package:flutter/material.dart';

import 'components/AbsenceSection.dart';
import 'components/UserProfile.dart';

class ProfileScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return ListView(
            children: [
                UserProfile(),
                Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: AbsenceSection(),
                ),
            ],
            padding: EdgeInsets.all(32),
        );
    }
}
