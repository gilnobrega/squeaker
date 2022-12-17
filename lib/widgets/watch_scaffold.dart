import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:wearable_rotary/wearable_rotary.dart';

class WatchScaffold extends StatelessWidget {
  final Widget? body;
  final Widget? title;
  final List<Widget>? actions;

  const WatchScaffold({
    super.key,
    this.body,
    this.title,
    this.actions,
  });

  static const _kBackgroundColor = Colors.black;
  static const _kFadeStop = 0.5;
  static const _kTopPadding = 3.0;
  static const _kBottomPadding = 3.0;

  @override
  Widget build(BuildContext context) {
    final windowWidth = MediaQuery.of(context).size.width;
    final windowHeight = MediaQuery.of(context).size.height;

    final contentWidth = windowWidth;
    final contentHeight = windowHeight;

    final r = contentWidth / 2;
    final side = math.sqrt(2) * r;
    final padding = (contentWidth - side) / 2;

    return Container(
      height: windowHeight,
      width: windowWidth,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: _kBackgroundColor,
      ),
      foregroundDecoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: contentHeight,
              width: contentWidth,
              color: _kBackgroundColor,
              margin: EdgeInsets.symmetric(horizontal: padding),
              child: SingleChildScrollView(
                controller: RotaryScrollController(),
                child: Column(
                  children: [
                    SizedBox(
                      height: padding + _kTopPadding,
                      width: side,
                    ),
                    if (body != null) body!,
                    SizedBox(
                      height: padding + _kBottomPadding,
                      width: side,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: side,
                height: padding + _kTopPadding,
                padding: const EdgeInsets.only(top: _kTopPadding),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    stops: [0.0, _kFadeStop],
                    colors: [Colors.transparent, _kBackgroundColor],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Center(
                  child: title,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: side,
                height: padding + _kBottomPadding,
                padding: const EdgeInsets.only(bottom: _kBottomPadding),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    stops: [0.0, _kFadeStop],
                    colors: [Colors.transparent, _kBackgroundColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  spacing: 32,
                  children: [
                    if (actions != null) ...actions!,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
