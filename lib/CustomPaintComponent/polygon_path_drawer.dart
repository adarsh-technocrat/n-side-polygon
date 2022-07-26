import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:n_side_progress_bar/CustomPaintComponent/polygon_spec.dart';

/// Class that draws a polygon path based on [PolygonPathSpecs].
class PolygonPathDrawer {
  final Size size;
  final PolygonPathSpecs specs;
  final double? headValue;
  final double? tailValue;
  final double? offsetValue;
  final double? rotationValue;

  /// Creates a polygon path drawer.
  PolygonPathDrawer({
    required this.size,
    required this.specs,
    this.headValue,
    this.tailValue,
    this.offsetValue,
    this.rotationValue,
  });

  Path draw() {
    final anglePerSide =
        360 / specs.sides; // Gives the Exterior Angle of any polygon

    final radius = (size.width - specs.borderRadiusAngle) / 2;
    final arcLength =
        (radius * _angleToRadian(specs.borderRadiusAngle)) + (specs.sides * 2);

    Path path = Path();

    for (var i = 0; i <= specs.sides; i++) {
      double currentAngle = anglePerSide * i;
      bool isFirst = i == 0;

      if (specs.borderRadiusAngle > 0) {
        _drawLineAndArc(path, currentAngle, radius, arcLength, isFirst);
      } else {
        _drawLine(path, currentAngle, radius, isFirst);
      }
    }

    return path;
  }

  Path drawAnimatedPath() {
    final anglePerSide =
        360 / specs.sides; // Gives the Exterior Angle of any polygon

    final radius = (size.width - specs.borderRadiusAngle) / 2;
    final arcLength =
        (radius * _angleToRadian(specs.borderRadiusAngle)) + (specs.sides * 2);

    Path path = Path();

    for (var i = 0; i <= specs.sides; i++) {
      double currentAngle = anglePerSide * i;
      bool isFirst = i == 0;

      if (specs.borderRadiusAngle > 0) {
        _drawLineAndArc(path, currentAngle, radius, arcLength, isFirst);
      } else {
        _drawLine(path, currentAngle, radius, isFirst);
      }
    }

    return path;
  }

  _drawLine(Path path, double currentAngle, double radius, bool move) {
    Offset current = _getOffset(currentAngle, radius);

    if (move) {
      path.moveTo(current.dx, current.dy);
    } else {
      path.lineTo(current.dx, current.dy);
    }
  }

  _drawLineAndArc(Path path, double currentAngle, double radius,
      double arcLength, bool isFirst) {
    double prevAngle = currentAngle - specs.halfBorderRadiusAngle;
    double nextAngle = currentAngle + specs.halfBorderRadiusAngle;

    Offset previous = _getOffset(prevAngle, radius);
    Offset next = _getOffset(nextAngle, radius);

    if (isFirst) {
      path.moveTo(next.dx, next.dy);
    } else {
      path.lineTo(previous.dx, previous.dy);
      path.arcToPoint(next, radius: Radius.circular(arcLength));
    }
  }

  double _angleToRadian(double angle) {
    return angle * (pi / 180);
  }

  Offset _getOffset(double angle, double radius) {
    final rotationAwareAngle = angle - 90 + specs.rotate;

    final radian = _angleToRadian(rotationAwareAngle);
    final x = cos(radian) * radius + radius + specs.halfBorderRadiusAngle;
    final y = sin(radian) * radius + radius + specs.halfBorderRadiusAngle;

    return Offset(x, y);
  }
}
