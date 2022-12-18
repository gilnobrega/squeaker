import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:wearable_rotary/wearable_rotary.dart';

class RotaryPageView extends StatefulWidget {
  final List<Widget> children;
  final RotaryScrollController? rotaryScrollController;

  const RotaryPageView(
      {super.key, required this.children, this.rotaryScrollController});

  @override
  State<RotaryPageView> createState() => _RotaryPageViewState();
}

class _RotaryPageViewState extends State<RotaryPageView> {
  late final RotaryScrollController _rotaryScrollController;
  final _pageController = PageController();

  static const _kVibrationDuration = 25;
  static const _kVibrationAmplitude = 64;

  static const _kPageSwitchAnimationDuration = Duration(milliseconds: 150);
  static const _kPageSwitchAnimationCurve = Curves.easeInOut;

  late final StreamSubscription<RotaryEvent> _rotarySubscription;

  Future<void> _scrollToPage(int addPage) {
    return _pageController.animateToPage(
      _pageController.page!.toInt() + addPage,
      duration: _kPageSwitchAnimationDuration,
      curve: _kPageSwitchAnimationCurve,
    );
  }

  void _rotaryEventListener(RotaryEvent event) {
    _scrollToPage(event.direction == RotaryDirection.clockwise ? 1 : -1);
    Vibration.vibrate(
        duration: _kVibrationDuration, amplitude: _kVibrationAmplitude);
  }

  @override
  void initState() {
    _rotaryScrollController = widget.rotaryScrollController ??
        RotaryScrollController(maxIncrement: 50);
    _rotarySubscription = rotaryEvents.listen(_rotaryEventListener);
    super.initState();
  }

  @override
  void dispose() {
    _rotarySubscription.cancel();
    _rotaryScrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      children: widget.children,
    );
  }
}
