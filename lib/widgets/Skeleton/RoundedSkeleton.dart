import 'package:FimaApp/widgets/Skeleton/Skeleton.dart';
import 'package:flutter/material.dart';

class RoundedSkeleton extends StatelessWidget {

    const RoundedSkeleton({
        Key key,
        this.color = const Color.fromARGB(255, 150, 150, 150),
        @required this.height,
        @required this.width,
    });
    
    final Color color;
    final double height;
    final double width;

    @override
    Widget build(BuildContext context) {
        return Skeleton(
            width: width,
            height: height,
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(32)),
        );
    }
}