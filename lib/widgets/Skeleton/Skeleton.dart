import 'dart:async';
import 'dart:math';

import 'package:FimaApp/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Skeleton extends HookWidget {

    const Skeleton({
        Key key,
        this.color = const Color.fromARGB(255, 150, 150, 150),
        @required this.height,
        @required this.width,
        this.refreshTime = const Duration(milliseconds: 50),
        this.refreshDistance = (1/12)*pi,
        this.borderRadius,
        this.minColorOpacity = 10,
        this.maxColorOpacity = 50,
    }): assert(0 <= minColorOpacity && minColorOpacity <= 255, 
        'minColorOpacity must be between 0 <= opacity <= 255'),
    assert(0 <= maxColorOpacity && maxColorOpacity <= 255, 
        'minColorOpacity must be between 0 <= opacity <= 255'),
    assert(minColorOpacity <= maxColorOpacity, 
        'minColorOpacity must be inferior or equals to maxColorOpacity');

    final Color color;
    final double height;
    final double width;
    final Duration refreshTime;
    final double refreshDistance;
    final BorderRadiusGeometry borderRadius;
    final int minColorOpacity;
    final int maxColorOpacity;

    @override
    Widget build(BuildContext context) {
        final timeController = useState<double>(0);

        useEffect(() {
            final timer = Timer.periodic(refreshTime, (timer) {
                timeController.value = timeController.value > 314.0
                    ? 0
                    : timeController.value + refreshDistance;
            });
            return () => timer.cancel();
        }, []);

        final computeAlpha = (double x, double t0) {
            final amplifiedSine = MathUtils.amplifiedSine(
                min: minColorOpacity, 
                max: maxColorOpacity);
            return amplifiedSine(x, t0);
        };

        return Container(
            decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: LinearGradient(
                    colors: [
                        color.withAlpha(computeAlpha(timeController.value, pi)),
                        color.withAlpha(computeAlpha(timeController.value, (3/4) * pi)),
                        color.withAlpha(computeAlpha(timeController.value, (2/4) * pi)),
                        color.withAlpha(computeAlpha(timeController.value, (1/4) * pi)),
                        color.withAlpha(computeAlpha(timeController.value, 0)),
                    ],
                ),
            ),
            width: width,
            height: height,
        );
    }
}
