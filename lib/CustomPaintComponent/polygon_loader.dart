import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:n_side_progress_bar/CustomPaintComponent/loder_painter.dart';
import 'package:n_side_progress_bar/CustomPaintComponent/polygon_spec.dart';

const double _kMinCircularProgressIndicatorSize = 36.0;

const int _kIndeterminateCircularDuration = 1333 * 2222;

enum _ActivityIndicatorType { material, adaptive }

abstract class NewProgressIndicator extends StatefulWidget {
  const NewProgressIndicator(
      {Key? key,
      this.value,
      this.backgroundColor,
      this.color,
      this.valueColor,
      this.semanticsLabel,
      this.semanticsValue,
      this.sides,
      this.borderRadius = 0.0,
      this.rotate = 0.0})
      : super(key: key);

  final double? value;

  final Color? backgroundColor;

  final Color? color;

  final Animation<Color?>? valueColor;

  final String? semanticsLabel;

  final String? semanticsValue;

  final int? sides;

  final double? rotate;

  final double? borderRadius;

  Color _getValueColor(BuildContext context) {
    return valueColor?.value ??
        color ??
        ProgressIndicatorTheme.of(context).color ??
        Theme.of(context).colorScheme.primary;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(PercentProperty('value', value,
        showName: false, ifNull: '<indeterminate>'));
  }

  Widget _buildSemanticsWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    String? expandedSemanticsValue = semanticsValue;
    if (value != null) {
      expandedSemanticsValue ??= '${(value! * 100).round()}%';
    }
    return Semantics(
      label: semanticsLabel,
      value: expandedSemanticsValue,
      child: child,
    );
  }
}

class PolygonProgressIndicator extends NewProgressIndicator {
  const PolygonProgressIndicator(
      {Key? key,
      double? value,
      Color? backgroundColor,
      Color? color,
      int? sides = 0,
      Animation<Color?>? valueColor,
      this.strokeWidth = 4.0,
      String? semanticsLabel,
      String? semanticsValue,
      double? borderRadius = 0.0,
      double? rotate = 0.0})
      : _indicatorType = _ActivityIndicatorType.material,
        super(
          key: key,
          value: value,
          sides: sides,
          borderRadius: borderRadius,
          rotate: rotate,
          backgroundColor: backgroundColor,
          color: color,
          valueColor: valueColor,
          semanticsLabel: semanticsLabel,
          semanticsValue: semanticsValue,
        );

  const PolygonProgressIndicator.adaptive({
    Key? key,
    double? value,
    Color? backgroundColor,
    Animation<Color?>? valueColor,
    this.strokeWidth = 4.0,
    String? semanticsLabel,
    String? semanticsValue,
    int? sides,
    double? rotate,
  })  : _indicatorType = _ActivityIndicatorType.adaptive,
        super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
          semanticsLabel: semanticsLabel,
          semanticsValue: semanticsValue,
          sides: sides,
          rotate: rotate,
        );

  final _ActivityIndicatorType _indicatorType;

  @override
  Color? get backgroundColor => super.backgroundColor;

  final double strokeWidth;

  @override
  State<PolygonProgressIndicator> createState() =>
      _PolygonProgressIndicatorState();
}

class _PolygonProgressIndicatorState extends State<PolygonProgressIndicator>
    with SingleTickerProviderStateMixin {
  static const int _pathCount = _kIndeterminateCircularDuration ~/ 1333;

  static const int _rotationCount = _kIndeterminateCircularDuration ~/ 2222;

  static final Animatable<double> _strokeHeadTween = CurveTween(
    curve: const Interval(0.0, 0.5, curve: Curves.fastOutSlowIn),
  ).chain(CurveTween(
    curve: const SawTooth(_pathCount),
  ));
  static final Animatable<double> _strokeTailTween = CurveTween(
    curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
  ).chain(CurveTween(
    curve: const SawTooth(_pathCount),
  ));
  static final Animatable<double> _offsetTween =
      CurveTween(curve: const SawTooth(_pathCount));
  static final Animatable<double> _rotationTween =
      CurveTween(curve: const SawTooth(_rotationCount));

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateCircularDuration),
      vsync: this,
    );
    if (widget.value == null) _controller.repeat();
  }

  @override
  void didUpdateWidget(PolygonProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating)
      _controller.repeat();
    else if (widget.value != null && _controller.isAnimating)
      _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildMaterialIndicator(BuildContext context, double headValue,
      double tailValue, double offsetValue, double rotationValue) {
    final Color? trackColor = widget.backgroundColor ??
        ProgressIndicatorTheme.of(context).circularTrackColor;

    PolygonPathSpecs specs = PolygonPathSpecs(
      sides: widget.sides! <= 0 ? 0 : widget.sides!,
      rotate: widget.rotate!,
      borderRadiusAngle: widget.borderRadius!,
    );

    return widget._buildSemanticsWrapper(
      context: context,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: _kMinCircularProgressIndicatorSize,
          minHeight: _kMinCircularProgressIndicatorSize,
        ),
        child: CustomPaint(
          painter: PolygonProgressIndicatorPainter(
            backgroundColor: trackColor,
            valueColor: widget._getValueColor(context),
            value: widget.value, // may be null
            headValue:
                headValue, // remaining arguments are ignored if widget.value is not null
            tailValue: tailValue,
            offsetValue: offsetValue,
            rotationValue: rotationValue,
            strokeWidth: widget.strokeWidth, specs: specs,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return _buildMaterialIndicator(
          context,
          _strokeHeadTween.evaluate(_controller),
          _strokeTailTween.evaluate(_controller),
          _offsetTween.evaluate(_controller),
          _rotationTween.evaluate(_controller),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) {
      return _buildMaterialIndicator(context, 0.0, 0.0, 0, 0.0);
    }
    return _buildAnimation();
  }
}
