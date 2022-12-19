import 'dart:async';

import 'package:flutter/material.dart';
import 'package:squeaker/widgets/round_scroll_bar.dart';
import 'package:vibration/vibration.dart';
import 'package:wearable_rotary/wearable_rotary.dart';

class RotaryPageView extends StatefulWidget {
  final List<Widget> children;
  final RotaryScrollController? rotaryScrollController;
  final PageController? pageController;
  final Duration duration;
  final Curve curve;
  final ScrollPhysics physics;
  final Axis scrollDirection;

  const RotaryPageView({
    super.key,
    required this.children,
    this.rotaryScrollController,
    this.pageController,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOutCirc,
    this.physics = const PageScrollPhysics(),
    this.scrollDirection = Axis.vertical,
  });

  @override
  State<RotaryPageView> createState() => _RotaryPageViewState();
}

class _RotaryPageViewState extends State<RotaryPageView> {
  late final RotaryScrollController _rotaryScrollController;
  late final PageController _pageController;

  static const _kVibrationDuration = 25;
  static const _kVibrationAmplitude = 64;

  late final StreamSubscription<RotaryEvent> _rotarySubscription;

  late int _currentPage;

  Future<void> _scrollToPage(int page) {
    return _pageController.animateToPage(
      page,
      duration: widget.duration,
      curve: widget.curve,
    );
  }

  bool _isAtEdge(RotaryDirection direction) {
    switch (direction) {
      case RotaryDirection.clockwise:
        return _currentPage == widget.children.length - 1;
      case RotaryDirection.counterClockwise:
        return _currentPage == 0;
    }
  }

  void _rotaryEventListener(RotaryEvent event) {
    if (_isAtEdge(event.direction)) return;
    _currentPage += (event.direction == RotaryDirection.clockwise ? 1 : -1);
    _scrollToPage(_currentPage);
    Vibration.vibrate(
      duration: _kVibrationDuration,
      amplitude: _kVibrationAmplitude,
    );
  }

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  @override
  void initState() {
    _pageController = widget.pageController ?? PageController();
    _currentPage = _pageController.initialPage;
    _rotaryScrollController = widget.rotaryScrollController ??
        RotaryScrollController(maxIncrement: 50);
    _rotarySubscription = rotaryEvents.listen(_rotaryEventListener);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
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
    return Stack(
      children: [
        PageView(
          controller: _pageController,
          scrollDirection: widget.scrollDirection,
          physics: widget.physics,
          onPageChanged: _onPageChanged,
          children: widget.children,
        ),
        if (_pageController.hasClients)
          IgnorePointer(
            child: RoundScrollBar(
              controller: _pageController,
            ),
          ),
      ],
    );
  }
}
