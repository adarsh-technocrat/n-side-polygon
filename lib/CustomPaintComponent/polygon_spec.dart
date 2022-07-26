class PolygonPathSpecs {
  final int sides;
  final double rotate;
  final double borderRadiusAngle;
  final double halfBorderRadiusAngle;

  /// [Creates polygon path specs.]
  PolygonPathSpecs({
    required this.sides,
    required this.rotate,
    required this.borderRadiusAngle,
  }) : halfBorderRadiusAngle = borderRadiusAngle / 2;
}
