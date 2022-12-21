import 'package:flutter/material.dart';
import 'package:squeaker/widgets/rotary_scroll_bar.dart';

class RotaryScrollWrapper extends StatelessWidget {
  /// A scrollable widget, such as [PageView] or [ListView] or [SingleChildScrollView].
  final Widget child;

  /// A scrollbar adapted to round screens that reacts to rotary events.
  final RotaryScrollBar rotaryScrollBar;

  /// Displays a [RotaryScrollBar] on top of a scrollable `child`.
  /// This can be a [PageView], [ListView], [SingleChildScrollView] or any other scroll view.
  const RotaryScrollWrapper({
    required this.rotaryScrollBar,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        IgnorePointer(
          child: rotaryScrollBar,
        ),
      ],
    );
  }
}
