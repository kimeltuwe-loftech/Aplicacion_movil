import 'dart:math' as math;
import 'package:flutter/material.dart';

class SpinningLoaderIcon extends StatefulWidget {
  final String assetName;
  final double size;

  const SpinningLoaderIcon({
    Key? key,
    required this.assetName,
    this.size = 48.0,
  }) : super(key: key);

  @override
  State<SpinningLoaderIcon> createState() => _SpinningLoaderIconState();
}

class _SpinningLoaderIconState extends State<SpinningLoaderIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Duration of one speed-up / slow-down cycle
  static const _cycleDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _cycleDuration,
    )..repeat(); // keeps cycling 0 -> 1 -> 0 -> ...
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _computeAngle(double t) {
    // t in [0,1], repeating every 3 seconds

    // Average number of full rotations per cycle (e.g. 2 rev / 3s)
    const double baseRotationsPerCycle = 2.0;

    // Amplitude of the speed variation (0 = constant speed)
    const double speedVariationAmplitude = 0.25;

    // f(t) is the total number of rotations since the start of the cycle.
    // Its derivative f'(t) is the instantaneous rotation speed.
    //
    //   f(t) = base * t + A * sin(2πt)
    //   f'(t) = base + A * 2π cos(2πt)
    //
    // Because sin(2π * 1) = 0, f(1) = base * 1 (an integer if base is integer),
    // so the angle is continuous across cycles.
    final rotations = baseRotationsPerCycle * t +
        speedVariationAmplitude * math.sin(2 * math.pi * t);

    // Convert rotations to radians: 1 rotation = 2π radians
    return 2 * math.pi * rotations;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = _computeAngle(_controller.value);
        return Transform.rotate(
          angle: angle,
          child: child,
        );
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Image.asset(widget.assetName),
      ),
    );
  }
}
