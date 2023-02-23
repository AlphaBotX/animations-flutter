import 'dart:async';
// import 'dart:html';
import 'dart:math';
import 'dart:ui';

import 'package:animation/animations/cube_animation.dart';
import 'package:flutter/material.dart' hide Image;

import 'animations/circle_complex_animation.dart';
import 'animations/rounded_rectangle_flip.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _cardController;
  late Timer timer;
  final List<Particle> particles = List.generate(150, (index) => Particle());
  @override
  void initState() {
    super.initState();
    const duration = Duration(milliseconds: 1);
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        // update animation
        particles.forEach((element) {
          element.pos += Offset(element.dx, element.dy);
        });
      });
    });
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
  }

  @override
  void dispose() {
    _cardController.dispose();
    timer.cancel();
    super.dispose();
  }

  double _Width = 100;
  double _Height = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                AnimationButton(
                    buttonTitle: 'Press for Rectangle Flip Animation',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const RoundedRectangleAnimation()),
                      );
                    }),
                AnimationButton(
                    buttonTitle: 'Press for Circle Flip Animation',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const CircleComplexAnimation()),
                      );
                    }),
                AnimationButton(
                    buttonTitle: 'Press for Cube Animation',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CubeAnimation()),
                      );
                    }),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => const CircleComplexAnimation()));
                //   },
                //   child: const Text('Press for Cube Animation'),
                // ),
              ]),
              AnimatedBuilder(
                  animation: _cardController,
                  builder: (context, child) {
                    return IgnorePointer(
                      child: CustomPaint(
                        painter: ClubPainter(
                          particles: particles,
                          width: _Width,
                          height: _Height,
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ClubPainter extends CustomPainter {
  final double width;
  final double height;
  final List<Particle> particles;
  ClubPainter({
    required this.width,
    required this.height,
    required this.particles,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(width, height);
    const radius = 100.0;
    final paint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.fill;

    // draw particles
    this.particles.forEach((p) {
      canvas.drawCircle(p.pos, p.radius, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class AnimationButton extends StatelessWidget {
  AnimationButton({
    this.onPressed,
    super.key,
    required this.buttonTitle,
  });
  final String buttonTitle;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: SizedBox(
          width: 240,
          child: Text(
            buttonTitle,
            textAlign: TextAlign.center,
          )),
    );
  }
}

class Particle {
  late double radius;
  late Color color;
  late Offset pos;
  late double dx;
  late double dy;
  Particle() {
    radius = Utils.randomDouble(3, 10);
    color = Colors.black26;

    final x = Utils.randomDouble(0, 50);
    final y = Utils.randomDouble(0, 50);
    pos = Offset(x, y);
    dx = Utils.randomDouble(-0.1, 0.1);
    dy = Utils.randomDouble(-0.1, 0.1);
  }
}

final random = Random();

class Utils {
  static double randomDouble(double min, double max) {
    return min + (max - min) * random.nextDouble();
  }
}
