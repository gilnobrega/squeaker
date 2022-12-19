// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

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
  final bool hasHapticFeedback;

  const RotaryPageView({
    super.key,
    required this.children,
    this.rotaryScrollController,
    this.pageController,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOutCirc,
    this.physics = const PageScrollPhysics(),
    this.scrollDirection = Axis.vertical,
    this.hasHapticFeedback = true,
  });

  @override
  State<RotaryPageView> createState() => _RotaryPageViewState();
}

class _RotaryPageViewState extends State<RotaryPageView> {
  late final RotaryScrollController _rotaryScrollController;
  late final PageController _pageController;

  static const _kVibrationDuration = 25;
  static const _kVibrationAmplitude = 64;
  static const _kOnEdgeVibrationDelay = Duration(seconds: 1);

  late final StreamSubscription<RotaryEvent> _rotarySubscription;

  late int _currentPage;

  void _scrollToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: widget.duration,
      curve: widget.curve,
    );

    if (!widget.hasHapticFeedback) return;
    Vibration.vibrate(
      duration: _kVibrationDuration,
      amplitude: _kVibrationAmplitude,
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

  int _getNextPage(RotaryEvent event) =>
      _currentPage + (event.direction == RotaryDirection.clockwise ? 1 : -1);

  void _rotaryEventListener(RotaryEvent event) {
    final nextPage = _getNextPage(event);

    if (_isAtEdge(event.direction)) {
      _scrollOnEdge(nextPage);
      return;
    }

    _scrollToPage(nextPage);
    _currentPage = nextPage;
  }

  bool _isVibrating = false;

  void _scrollOnEdge(int outOfEdgePage) {
    if (_isVibrating) return;

    _isVibrating = true;
    _scrollToPage(outOfEdgePage);
    _pageController.notifyListeners();
    Future.delayed(_kOnEdgeVibrationDelay, () => _isVibrating = false);
  }

  void _onPageChanged(int newPage) {
    setState(() => _currentPage = newPage);
  }

  @override
  void initState() {
    _initPageController();
    _initRotaryScrollController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState);
  }

  void _initPageController() {
    _pageController = widget.pageController ?? PageController();
    _currentPage = _pageController.initialPage;
  }

  void _initRotaryScrollController() {
    _rotaryScrollController = widget.rotaryScrollController ??
        RotaryScrollController(maxIncrement: 50);
    _rotarySubscription = rotaryEvents.listen(_rotaryEventListener);
  }

  @override
  void dispose() {
    _disposeRotaryScrollController();
    _disposePageController();
    super.dispose();
  }

  void _disposeRotaryScrollController() {
    _rotarySubscription.cancel();
    _rotaryScrollController.dispose();
  }

  void _disposePageController() {
    _pageController.dispose();
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
