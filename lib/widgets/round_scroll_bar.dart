import 'package:flutter/material.dart';
import 'dart:math' as math;

class RoundScrollBar extends StatefulWidget {
  final ScrollController controller;
  final double padding;
  final double width;
  final bool autoHide;
  final Curve opacityAnimationCurve;
  final Duration autoHideDuration;
  final Duration opacityAnimationDuration;

  const RoundScrollBar({
    super.key,
    required this.controller,
    this.padding = 8,
    this.width = 8,
    this.autoHide = true,
    this.opacityAnimationCurve = Curves.easeInOut,
    this.opacityAnimationDuration = const Duration(milliseconds: 250),
    this.autoHideDuration = const Duration(seconds: 3),
  });

  @override
  State<RoundScrollBar> createState() => _RoundScrollBarState();
}

class _RoundScrollBarState extends State<RoundScrollBar> {
  // starts at the 2pm marker on an analog watch
  static const _kProgressBarStartingPoint = math.pi * (-1 / 2 + 1 / 3);
  // finishes at the 4pm marker on an analog watch
  static const _kProgressBarLength = math.pi / 3;

  late double _index;
  late double _length;

  bool _isScrollBarVisible = true;

  void _onScrolled() {
    setState(() {
      _isScrollBarVisible = true;
      _updateScrollValues();
    });
    _hideAfterDelay();
  }

  void _hideAfterDelay() {
    if (!widget.autoHide) return;
    Future.delayed(widget.autoHideDuration, () {
      setState(() => _isScrollBarVisible = false);
    });
  }

  _updateScrollValues() {
    _length = (widget.controller.position.maxScrollExtent /
        widget.controller.position.viewportDimension);
    _length++;

    _index = (widget.controller.offset /
        widget.controller.position.viewportDimension);
  }

  @override
  void initState() {
    _updateScrollValues();
    widget.controller.addListener(_onScrolled);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _hideAfterDelay());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScrolled);
    super.dispose();
  }

  Widget _addAnimatedOpacity({required Widget child}) {
    if (!widget.autoHide) return child;

    return AnimatedOpacity(
      opacity: _isScrollBarVisible ? 1 : 0,
      duration: widget.opacityAnimationDuration,
      curve: widget.opacityAnimationCurve,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _addAnimatedOpacity(
      child: Stack(
        children: [
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _RoundProgressBarPainter(
              angleLength: _kProgressBarLength,
              color: Theme.of(context).highlightColor,
              startingAngle: _kProgressBarStartingPoint,
              trackPadding: widget.padding,
              trackWidth: widget.width,
            ),
          ),
          Transform.rotate(
            angle: _index * (_kProgressBarLength / _length),
            child: CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _RoundProgressBarPainter(
                angleLength: (_kProgressBarLength / _length),
                startingAngle: _kProgressBarStartingPoint,
                color: Theme.of(context).highlightColor.withOpacity(1.0),
                trackPadding: widget.padding,
                trackWidth: widget.width,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _RoundProgressBarPainter extends CustomPainter {
  final double startingAngle;
  final double angleLength;
  final Color color;
  final double trackWidth;
  final double trackPadding;

  _RoundProgressBarPainter({
    required this.angleLength,
    required this.color,
    required this.trackPadding,
    required this.trackWidth,
    this.startingAngle = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = trackWidth.toDouble()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final centerOffset = Offset(
      size.width / 2,
      size.height / 2,
    );

    final innerWidth = size.width - trackPadding * 2 - trackWidth;
    final innerHeight = size.height - trackPadding * 2 - trackWidth;

    final path = Path()
      ..arcTo(
        Rect.fromCenter(
          center: centerOffset,
          width: innerWidth,
          height: innerHeight,
        ),
        startingAngle,
        angleLength,
        true,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _RoundProgressBarPainter oldDelegate) {
    return color != oldDelegate.color ||
        startingAngle != oldDelegate.startingAngle ||
        angleLength != oldDelegate.angleLength ||
        trackWidth != oldDelegate.trackWidth ||
        trackPadding != oldDelegate.trackPadding;
  }
}
