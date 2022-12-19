import 'package:flutter/material.dart';
import 'dart:math' as math;

const _kProgressBarStartingPoint = math.pi * (-1 / 2 + 1 / 3);
const _kProgressBarLength = math.pi / 3;

class RoundScrollBar extends StatelessWidget {
  final int length;
  final int index;
  final Curve curve;
  final Duration duration;
  final double padding;
  final double width;

  const RoundScrollBar({
    super.key,
    required this.index,
    required this.length,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOut,
    this.padding = 8,
    this.width = 4,
  });

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
            trackPadding: padding,
            trackWidth: width,
          ),
        ),
        AnimatedRotation(
          duration: duration,
          curve: curve,
          turns: _kProgressBarLength / length / (math.pi * 2) * index,
          child: CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _RoundProgressBarPainter(
              angleLength: (_kProgressBarLength / length),
              startingAngle: _kProgressBarStartingPoint,
              color: Theme.of(context).highlightColor.withOpacity(1.0),
              trackPadding: padding,
              trackWidth: width,
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
    Paint paint = Paint()
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

    final path = Path();

    path.arcTo(
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
