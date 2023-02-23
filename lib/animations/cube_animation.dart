import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class CubeAnimation extends StatefulWidget {
  const CubeAnimation({super.key});

  @override
  State<CubeAnimation> createState() => _CubeAnimationState();
}

class _CubeAnimationState extends State<CubeAnimation>
    with TickerProviderStateMixin {
  late AnimationController _xcontroller;
  late AnimationController _ycontroller;
  late AnimationController _zcontroller;

  late Tween<double> _animation;

  @override
  void initState() {
    _xcontroller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _ycontroller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    _zcontroller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    );

    _animation = Tween<double>(begin: 0, end: pi * 2);

    _xcontroller
      ..reset()
      ..repeat();
    _ycontroller
      ..reset()
      ..repeat();
    _zcontroller
      ..reset()
      ..repeat();

    super.initState();
  }

  @override
  void dispose() {
    _xcontroller.dispose();
    _ycontroller.dispose();
    _zcontroller.dispose();

    super.dispose();
  }

  double widthAndHeight = 100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            AnimatedBuilder(
                animation: Listenable.merge([
                  _xcontroller,
                  _ycontroller,
                  _zcontroller,
                ]),
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateX(
                        _animation.evaluate(_xcontroller),
                      )
                      ..rotateY(
                        _animation.evaluate(_ycontroller),
                      )
                      ..rotateZ(
                        _animation.evaluate(_zcontroller),
                      ),
                    child: Stack(
                      children: [
                        /// Left
                        Transform(
                          alignment: Alignment.centerLeft,
                          transform: Matrix4.identity()..rotateY(pi / 2),
                          child: Container(
                            color: Colors.red,
                            width: widthAndHeight,
                            height: widthAndHeight,
                          ),
                        ),

                        /// Right
                        Transform(
                          alignment: Alignment.centerRight,
                          transform: Matrix4.identity()..rotateY(-pi / 2),
                          child: Container(
                            color: Colors.yellow,
                            width: widthAndHeight,
                            height: widthAndHeight,
                          ),
                        ),

                        /// Back
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..translate(
                              Vector3(0, 0, -widthAndHeight),
                            ),
                          child: Container(
                            height: widthAndHeight,
                            width: widthAndHeight,
                            color: Colors.purple,
                          ),
                        ),

                        /// Front
                        Container(
                          height: widthAndHeight,
                          width: widthAndHeight,
                          color: Colors.green,
                        ),

                        /// Top
                        Transform(
                          alignment: Alignment.topCenter,
                          transform: Matrix4.identity()..rotateX(-pi / 2),
                          child: Container(
                            height: widthAndHeight,
                            width: widthAndHeight,
                            color: Colors.orange,
                          ),
                        ),

                        // Bottom
                        Transform(
                          alignment: Alignment.bottomCenter,
                          transform: Matrix4.identity()
                            // ..translate(Vector3(0, widthAndHeight, 0))
                            ..rotateX(pi / 2),
                          child: Container(
                            height: widthAndHeight,
                            width: widthAndHeight,
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
