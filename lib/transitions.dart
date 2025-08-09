import 'package:flutter/material.dart';

// Durations for forward and reverse animations
const Duration kForwardDuration = Duration(milliseconds: 320);
const Duration kReverseDuration = Duration(milliseconds: 280);

/// Fade transition route
class FadePageRoute<T> extends PageRouteBuilder<T> {
  FadePageRoute({required Widget page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: kForwardDuration,
          reverseTransitionDuration: kReverseDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved =
                CurvedAnimation(parent: animation, curve: Curves.easeOut);
            return FadeTransition(opacity: curved, child: child);
          },
        );
}

/// Slide from right transition route
class SlideRightPageRoute<T> extends PageRouteBuilder<T> {
  SlideRightPageRoute({required Widget page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: kForwardDuration,
          reverseTransitionDuration: kReverseDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved =
                CurvedAnimation(parent: animation, curve: Curves.easeOut);
            return SlideTransition(
              position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .animate(curved),
              child: child,
            );
          },
        );
}

/// Scale + Fade transition with easeOutBack curve
class ScaleFadePageRoute<T> extends PageRouteBuilder<T> {
  ScaleFadePageRoute({required Widget page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: kForwardDuration,
          reverseTransitionDuration: kReverseDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final scale = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            );
            final fade =
                CurvedAnimation(parent: animation, curve: Curves.easeOut);
            return FadeTransition(
              opacity: fade,
              child: ScaleTransition(scale: scale, child: child),
            );
          },
        );
}
  class FadeTransitionsBuilder extends PageTransitionsBuilder {
    const FadeTransitionsBuilder();

    @override
    Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(opacity: curved, child: child);
    }
  }

