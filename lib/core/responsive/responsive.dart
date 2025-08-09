// Responsive utilities for Swappy
// Defines breakpoints, size classes, and spacing helpers.

import 'package:flutter/material.dart';

/// Breakpoints used across the app.
class Breakpoints {
  static const double phone = 0;        // up to 599
  static const double tablet = 600;     // 600–1023
  static const double desktop = 1024;   // 1024+
}

/// Size classes representing the current screen width.
enum SizeClass { phone, tablet, desktop }

/// Extension helpers to easily query responsive information from [BuildContext].
extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double get width => screenSize.width;
  double get height => screenSize.height;

  /// Returns the [SizeClass] for the current width.
  SizeClass get sizeClass {
    final w = width;
    if (w >= Breakpoints.desktop) return SizeClass.desktop;
    if (w >= Breakpoints.tablet) return SizeClass.tablet;
    return SizeClass.phone;
  }

  bool get isPhone => sizeClass == SizeClass.phone;
  bool get isTablet => sizeClass == SizeClass.tablet;
  bool get isDesktop => sizeClass == SizeClass.desktop;
}

/// Returns the base space used between components.
/// Scales with the current [SizeClass].
double space(BuildContext c) =>
    c.isDesktop ? 24 : c.isTablet ? 16 : 12;

/// Returns the outer gutter/padding value for pages.
/// Scales with the current [SizeClass].
double gutter(BuildContext c) =>
    c.isDesktop ? 32 : c.isTablet ? 24 : 16;

/// Responsive headline style adapting to the current width.
TextStyle headline(BuildContext c, ThemeData t) =>
    t.textTheme.headlineSmall!.copyWith(
      fontSize: c.isDesktop ? 28 : c.isTablet ? 24 : 20,
    );
