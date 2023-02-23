import 'dart:math';

import 'package:animation/home.dart';
import 'package:flutter/material.dart';

enum CircleSide { left, right }

extension ToPath on CircleSide {
  Path toPath(Size size) {
    var path = Path();

    late Offset offset;
    late bool clockwise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockwise = false;

        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockwise = true;
        break;
    }
    path.arcToPoint(offset,
        radius: Radius.elliptical(size.width / 2, size.height / 2),
        clockwise: clockwise);
    path.close();
    return path;
  }
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  const HalfCircleClipper({required this.side});

  @override
  Path getClip(Size size) {
    return side.toPath(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CircleComplexAnimation extends StatefulWidget {
  const CircleComplexAnimation({
    super.key,
  });

  @override
  State<CircleComplexAnimation> createState() => _CircleComplexAnimationState();
}

class _CircleComplexAnimationState extends State<CircleComplexAnimation>
    with TickerProviderStateMixin {
  late AnimationController _counterClockwiseRotationController;
  late Animation<double> _counterClockwiseRotationAnimation;

  late AnimationController _flipCardController;
  late Animation<double> _flipAnimation;
  @override
  void initState() {
    super.initState();

    // for counter clockwise rotation
    _counterClockwiseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _counterClockwiseRotationAnimation = Tween<double>(
      begin: 0,
      end: -(pi / 2),
    ).animate(CurvedAnimation(
        parent: _counterClockwiseRotationController, curve: Curves.bounceOut));

    // for flip animation
    _flipCardController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _flipCardController, curve: Curves.bounceOut),
    );

    //  listen to the status of the counterClockwiseRotationController
    _counterClockwiseRotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation = Tween<double>(
          begin: _flipAnimation.value,
          end: _flipAnimation.value + pi,
        ).animate(
          CurvedAnimation(parent: _flipCardController, curve: Curves.bounceOut),
        );
        _flipCardController
          ..reset()
          ..forward();
      }
    });
    _flipCardController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counterClockwiseRotationAnimation = Tween<double>(
          begin: _counterClockwiseRotationAnimation.value,
          end: _counterClockwiseRotationAnimation.value - (pi / 2),
        ).animate(CurvedAnimation(
            parent: _counterClockwiseRotationController,
            curve: Curves.bounceOut));
        _counterClockwiseRotationController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    _counterClockwiseRotationController.dispose();
    _flipCardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _counterClockwiseRotationController
      ..reset()
      ..forward.delayed(
        const Duration(milliseconds: 200),
      );

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([
              _counterClockwiseRotationController,
              _flipCardController,
            ]),
            builder: (context, child) {
              double semiCircleHeight = 150;
              double semiCircleWidth = 150;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateZ(_counterClockwiseRotationAnimation.value),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform(
                      alignment: Alignment.centerRight,
                      transform: Matrix4.identity()
                        ..rotateY(_flipAnimation.value),
                      child: ClipPath(
                        clipper: const HalfCircleClipper(side: CircleSide.left),
                        child: Container(
                          height: semiCircleHeight,
                          width: semiCircleWidth,
                          color: Colors.blue,
                        ),
                      ),
                    ),

                    Transform(
                      alignment: Alignment.centerLeft,
                      transform: Matrix4.identity()
                        ..rotateY(_flipAnimation.value),
                      child: ClipPath(
                        clipper:
                            const HalfCircleClipper(side: CircleSide.right),
                        child: Container(
                          height: semiCircleHeight,
                          width: semiCircleWidth,
                          color: Colors.pink,
                        ),
                      ),
                    ),

                    ///Animation for Y axis flip
                  ],
                ),
              );
            },
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Go back"))
        ],
      ),
    );
  }
}
