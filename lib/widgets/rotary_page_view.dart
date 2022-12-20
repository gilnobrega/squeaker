import 'package:flutter/material.dart';
import 'package:squeaker/widgets/rotary_scroll_bar.dart';
import 'package:squeaker/widgets/round_scroll_bar.dart';

class RotaryPageView extends StatefulWidget {
  /// Creates a scrollable list that works page by page from an explicit [List] of widgets.
  final List<Widget> children;

  /// A [PageController] may be provided.
  final PageController? pageController;

  /// Duration of the animation between page transitions.
  final Duration duration;

  /// Animation curve for page transitions.
  final Curve curve;

  /// Scroll physics for [PageView]
  final ScrollPhysics physics;

  /// Scroll direction.
  /// Defaults to `Axis.vertical` as `Axis.horizontal` may be misinterpreted by wearOS as back button.
  final Axis scrollDirection;

  /// Whether device should vibrate after each page transition.
  final bool hasHapticFeedback;

  /// A [PageView] adapted to rounded screens in wearOS.
  /// Includes a [RoundScrollBar]
  /// Similar to the generic [PageView] constructor where an explicit list of [children] must be provided.
  const RotaryPageView({
    required this.children,
    this.pageController,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOutCirc,
    this.physics = const PageScrollPhysics(),
    this.scrollDirection = Axis.vertical,
    this.hasHapticFeedback = true,
    super.key,
  });

  @override
  State<RotaryPageView> createState() => _RotaryPageViewState();
}

class _RotaryPageViewState extends State<RotaryPageView> {
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = widget.pageController ?? PageController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _pageController,
          scrollDirection: widget.scrollDirection,
          physics: widget.physics,
          children: widget.children,
        ),
        if (_pageController.hasClients)
          IgnorePointer(
            child: RotaryScrollBar(
              controller: _pageController,
            ),
          ),
      ],
    );
  }
}
