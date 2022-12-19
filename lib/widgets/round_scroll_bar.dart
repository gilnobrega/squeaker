import 'package:flutter/material.dart';
import 'dart:math' as math;

const _kProgressBarStartingPoint = math.pi * (-1 / 2 + 1 / 3);
const _kProgressBarLength = math.pi / 3;

class RoundScrollBar extends StatefulWidget {
  final ScrollController controller;
  final double padding;
  final double width;

  const RoundScrollBar({
    super.key,
    required this.controller,
    this.padding = 8,
    this.width = 4,
  });

  @override
  State<RoundScrollBar> createState() => _RoundScrollBarState();
}

class _RoundScrollBarState extends State<RoundScrollBar> {
  late double index;
  late double length;
  void _onScrolled() {
    setState(_updateValues);
  }

  _updateValues() {
    length = (widget.controller.position.maxScrollExtent /
        widget.controller.position.viewportDimension);
    length++;

    index = (widget.controller.offset /
        widget.controller.position.viewportDimension);
  }

  @override
  void initState() {
    _updateValues();
    widget.controller.addListener(_onScrolled);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScrolled);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
          angle: index * (_kProgressBarLength / length),
          child: CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _RoundProgressBarPainter(
              angleLength: (_kProgressBarLength / length),
              startingAngle: _kProgressBarStartingPoint,
              color: Theme.of(context).highlightColor.withOpacity(1.0),
              trackPadding: widget.padding,
              trackWidth: widget.width,
            ),
          ),
        )
      ],
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
