import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../riverpod/river_pod.dart';



class CardFlipper extends ConsumerStatefulWidget {
  const CardFlipper({Key? key, }) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<CardFlipper>
    with SingleTickerProviderStateMixin {


  bool isFront = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var k = ref.watch(themeProvider);
      k.controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
      );

      k.animation = Tween<double>(begin: 0, end: 1).animate(k.controller);
    });

  }

  @override
  void dispose() {
    var k = ref.watch(themeProvider);
    k.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var k = ref.watch(themeProvider);
    return GestureDetector(
      onTap: () {
print('isFront $isFront') ;
        if (isFront) {
          k.controller.forward();
        } else {
          k.controller.reverse();
        }
        isFront = !isFront;
      },
      child: AnimatedSwitcher(
        duration: Duration(seconds: 1),
        transitionBuilder: (child, animation) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(k.animation.value * math.pi),
            child: child,
          );
        },
        child: isFront
            ? Card(
          color: Colors.red,
          child: Center(
            child: Text('Front'),
          ),
        )
            : Card(
          color: Colors.blue,
          child: Center(
            child: Text('Back'),
          ),
        ),
      ),
    );
  }
}
