import 'package:flutter/material.dart';
import 'package:n_side_progress_bar/CustomPaintComponent/polygon_path_drawer.dart';
import 'dart:math' as math;

import 'package:n_side_progress_bar/CustomPaintComponent/polygon_spec.dart';

class PolygonProgressIndicatorPainter extends CustomPainter {
  PolygonProgressIndicatorPainter(
      {this.backgroundColor,
      required this.valueColor,
      required this.value,
      required this.headValue,
      required this.tailValue,
      required this.offsetValue,
      required this.rotationValue,
      required this.strokeWidth,
      required this.specs})
      : arcStart = value != null
            ? _startAngle
            : _startAngle +
                tailValue * 3 / 2 * math.pi +
                rotationValue * math.pi * 2.0 +
                offsetValue * 0.5 * math.pi,
        arcSweep = value != null
            ? value.clamp(0.0, 1.0) * _sweep
            : math.max(
                headValue * 3 / 2 * math.pi - tailValue * 3 / 2 * math.pi,
                _epsilon);

  final Color? backgroundColor;
  final Color valueColor;
  final double? value;
  final double headValue;
  final double tailValue;
  final double offsetValue;
  final double rotationValue;
  final double strokeWidth;
  final double arcStart;
  final double arcSweep;
  final PolygonPathSpecs specs;

  static const double _twoPi = math.pi * 2.0;
  static const double _epsilon = .001;

  static const double _sweep = _twoPi - _epsilon;
  static const double _startAngle = -math.pi / 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = valueColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Paint backgroundPaint = Paint()
      ..color = backgroundColor!
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    if (specs.sides < 3) {
      if (backgroundColor != null) {
        canvas.drawArc(Offset.zero & size, 0, _sweep, false, backgroundPaint);
      }

      if (value == null) {
        paint.strokeCap = StrokeCap.square;
      }

      canvas.drawArc(Offset.zero & size, arcStart, arcSweep, false, paint);
    } else {
      Path path = PolygonPathDrawer(
        size: size,
        specs: specs,
      ).draw();
      Path animatedPath = PolygonPathDrawer(
              size: size,
              specs: specs,
              headValue: headValue,
              tailValue: tailValue,
              offsetValue: offsetValue,
              rotationValue: rotationValue)
          .drawAnimatedPath();

      if (backgroundColor != null) {
        canvas.drawPath(path, backgroundPaint);
      }
      canvas.drawPath(animatedPath, paint);
    }
  }

  @override
  bool shouldRepaint(PolygonProgressIndicatorPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value ||
        oldPainter.headValue != headValue ||
        oldPainter.tailValue != tailValue ||
        oldPainter.offsetValue != offsetValue ||
        oldPainter.rotationValue != rotationValue ||
        oldPainter.strokeWidth != strokeWidth;
  }
}
