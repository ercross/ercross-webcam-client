part of '../home.dart';

/// A custom painter for drawing dashed shapes (circle or rounded rectangle) on a canvas.
class DashedCirclePainter extends CustomPainter {
  /// [strokeWidth] is the width of the dashed stroke as a percentage of circle size.
  final double strokeWidth;

  /// [dashWidth] is the width of each dash as a percentage of circle size.
  final double dashWidth;
  
  /// [dashSpace] is the space between dashes as a percentage of circle size.
  final double dashSpace;

  /// - [strokeColor] is the color of the dashed stroke.
  final Color strokeColor;

  DashedCirclePainter({
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.strokeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * (strokeWidth / 100);

    _drawDashedCircle(canvas, size, paint);
  }

  void _drawDashedCircle(Canvas canvas, Size size, Paint paint) {
    final radius = size.width / 2;
    final circumference = 2 * pi * radius;
    final scaledDashWidth = _scaleDashWidth(size);
    final scaledDashSpace = _scaleDashSpace(size);
    final dashCount = (circumference / (scaledDashWidth + scaledDashSpace)).floor();
    final adjustedDashSpace =
        (circumference - (scaledDashWidth * dashCount)) / dashCount;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = (i * (scaledDashWidth + adjustedDashSpace)) / radius;
      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2), radius: radius),
        startAngle,
        scaledDashWidth / radius,
        false,
        paint,
      );
    }
  }

  double _scaleDashWidth(Size size) {
    return size.width * (dashWidth / 100);
  }

  double _scaleDashSpace(Size size) {
    return size.width * (dashSpace / 100);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}