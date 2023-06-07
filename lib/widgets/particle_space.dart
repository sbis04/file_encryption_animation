import 'dart:math';

import 'package:flutter/material.dart';

class ParticlesMotion extends StatefulWidget {
  final int totalParticles;
  final double speed;
  final bool isRunning;

  const ParticlesMotion({
    Key? key,
    required this.totalParticles,
    required this.speed,
    required this.isRunning,
  }) : super(key: key);

  @override
  State<ParticlesMotion> createState() => _ParticlesMotionState();
}

class _ParticlesMotionState extends State<ParticlesMotion>
    with SingleTickerProviderStateMixin {
  late final Random _random;
  late final AnimationController _controller;

  List<Particle> _particles = [];
  double angle = 0;
  double width = 0;
  double height = 0;
  int count = 0;

  @override
  void initState() {
    _random = Random();
    _controller = AnimationController(
      lowerBound: 0,
      upperBound: 1,
      vsync: this,
      duration: const Duration(milliseconds: 30000),
    )..addListener(() {
        if (mounted) setState(() => update());
      });

    if (!widget.isRunning) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  _createParticle() {
    _particles = [];
    for (var i = 0; i < widget.totalParticles; i++) {
      _particles.add(
        Particle(
          y: _random.nextDouble() * width,
          x: _random.nextDouble() * height,
          r: _random.nextDouble() * 1 + 1,
          d: _random.nextDouble() * widget.speed,
          color: Colors.white.withOpacity(min(0.1 + _random.nextDouble(), 0.6)),
        ),
      );
    }
  }

  update() {
    angle += 0.00;
    if (widget.totalParticles != _particles.length) {
      _createParticle();
    }
    for (int i = 0; i < widget.totalParticles; i++) {
      final particle = _particles[i];
      if (count <= 100) {
        count++;
      }

      particle.x +=
          (cos(angle + particle.d) + 1 + particle.r / 2) * widget.speed;
      particle.y += sin(angle) * 2 * widget.speed;

      if (particle.x > width + 5 || particle.x < -5 || particle.y > height) {
        final particleColor = Colors.white.withOpacity(
            count > 100 ? min(0.2 + _random.nextDouble(), 0.8) : 0);
        if (i % 3 > 0) {
          // 66.67% of the particles
          _particles[i] = Particle(
            y: _random.nextDouble() * width,
            x: -10,
            r: particle.r,
            d: particle.d,
            color: particleColor,
          );
        } else {
          // If the particle is exiting from the right
          if (sin(angle) > 0) {
            // Enter from the left
            _particles[i] = Particle(
              y: -5,
              x: _random.nextDouble() * height,
              r: particle.r,
              d: particle.d,
              color: particleColor,
            );
          } else {
            // Enter from the right
            _particles[i] = Particle(
              y: width + 5,
              x: _random.nextDouble() * height,
              r: particle.r,
              d: particle.d,
              color: particleColor,
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isRunning && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isRunning && _controller.isAnimating) {
      _controller.stop();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        width = constraints.maxWidth;
        height = constraints.maxHeight;
        return CustomPaint(
          willChange: widget.isRunning,
          painter: ParticlePainter(
            isRunning: widget.isRunning,
            particles: _particles,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  double r; //radius
  double d; //density
  Color color;

  Particle({
    required this.x,
    required this.y,
    required this.r,
    required this.d,
    required this.color,
  });
}

class ParticlePainter extends CustomPainter {
  List<Particle>? particles;
  bool isRunning;

  ParticlePainter({
    required this.isRunning,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (particles == null || !isRunning) return;

    // draw particle
    for (var i = 0; i < particles!.length; i++) {
      var particle = particles![i];
      final Paint paint = Paint()..color = particle.color;
      final position = Offset(particle.x, particle.y);
      canvas.drawCircle(position, particle.r, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => isRunning;
}
