import 'package:flutter/material.dart';

class ServiceCardActionDialogSectionTitle extends StatelessWidget {
    const ServiceCardActionDialogSectionTitle({
        Key key,
        @required this.title,
    }) : super(key: key);

    final String title;

    @override
    Widget build(BuildContext context) {
        return Text(
            title,
            style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600]
            ),
        );
    }
}
