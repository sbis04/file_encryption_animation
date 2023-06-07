import 'package:file_encryption_animation/widgets/particle_space.dart';
import 'package:file_encryption_animation/widgets/sensitive_document.dart';
import 'package:flutter/material.dart';

const int delaySeconds = 15;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double leftDist = -300.0;
  double width = 0.0;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: delaySeconds), () {
      setState(() {
        leftDist = width + 300;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900,
      body: Container(
        color: Colors.black.withOpacity(0.75),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                ParticleSpace(spaceWidth: width),
                AnimatedPositioned(
                  duration: const Duration(seconds: 20),
                  left: leftDist,
                  child: const SensitiveDocument(
                    scale: 0.8,
                    shredMilliseconds: 3350,
                    delayMilliseconds: delaySeconds * 1000 + 6200,
                  ),
                ),
                const Shredder(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ParticleSpace extends StatelessWidget {
  const ParticleSpace({
    super.key,
    required this.spaceWidth,
  });

  final double spaceWidth;

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: 365,
      child: ParticlesMotion(
        isRunning: true,
        totalParticles: 500,
        speed: 4,
      ),
    );
  }
}

class ParticlesPainter extends CustomPainter {
  final _paint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height / 2)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Shredder extends StatefulWidget {
  const Shredder({super.key});

  @override
  State<Shredder> createState() => _ShredderState();
}

class _ShredderState extends State<Shredder> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: ShredderPainter(),
      child: Container(
        clipBehavior: Clip.none,
        width: 16,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.elliptical(16, 100),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.6),
              blurRadius: 16.0,
              spreadRadius: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}

class ShredderPainter extends CustomPainter {
  final centerWidth = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width / 2, 0) // top center point
      ..quadraticBezierTo(size.width / 2 - centerWidth / 2, size.height / 2,
          size.width / 2, size.height) // left curve
      ..quadraticBezierTo(size.width / 2 + centerWidth / 2, size.height / 2,
          size.width / 2, 0) // right curve
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
