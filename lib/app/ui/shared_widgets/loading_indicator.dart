import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../colors.dart';

class AppLoadingIndicator extends StatelessWidget {
  final Color colorDeep;
  final Color colorLight;
  final bool displayInButton;
  const AppLoadingIndicator(
      {super.key,
      this.displayInButton = false,
      this.colorDeep = AppColor.primary,
      this.colorLight = const Color(0xFFD2D1FF)});

  @override
  Widget build(BuildContext context) {
    
    final double size = displayInButton ? 25 : 38;
    return Material(
      color: Colors.transparent,
      child: Center(
        child: SizedBox(
            height: size,
            width: size,
            child: AnimatedGradientCircle(
              colorDeep: colorDeep,
              colorLight: colorLight,
            )),
      ),
    );
  }
}

class AnimatedGradientCircle extends StatefulWidget {
  final Color colorDeep;
  final Color colorLight;

  const AnimatedGradientCircle({
    this.colorDeep = AppColor.primary,
    this.colorLight = const Color(0xFFD2D1FF),
    super.key,
  });

  @override
  State<AnimatedGradientCircle> createState() => _AnimatedGradientCircleState();
}

class _AnimatedGradientCircleState extends State<AnimatedGradientCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0, // Start rotation angle
      end: 2 * 3.141, // End rotation angle (2 * pi for a full circle)
    ).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Transform.rotate(
          angle: _animation.value,
          child: CustomPaint(
              painter: _GradientCirclePainter(
                  colorDeep: widget.colorDeep, colorLight: widget.colorLight))),
    );
  }
}

class _GradientCirclePainter extends CustomPainter {
  final Color colorDeep;
  final Color colorLight;
  _GradientCirclePainter({required this.colorDeep, required this.colorLight});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint();
    paint.strokeWidth = 4;
    paint.style = PaintingStyle.stroke;
    paint.shader = ui.Gradient.sweep(
        center,
        [Colors.white.withOpacity(0.05), colorLight, colorDeep],
        [0.2, 0.3, 0.9]);
    Path path = Path();
    path.addArc(
        Rect.fromCenter(center: center, width: size.width, height: size.height),
        math.pi,
        2 * math.pi);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
