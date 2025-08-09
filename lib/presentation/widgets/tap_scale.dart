import 'package:flutter/material.dart';

class TapScale extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const TapScale({super.key, required this.child, this.duration = const Duration(milliseconds: 90)});

  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale> {
  double _scale = 1.0;

  void _animateTo(double target) {
    if (MediaQuery.of(context).disableAnimations) return;
    setState(() => _scale = target);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _animateTo(0.97),
      onPointerUp: (_) => _animateTo(1.0),
      onPointerCancel: (_) => _animateTo(1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: widget.duration,
        child: widget.child,
      ),
    );
  }
}
