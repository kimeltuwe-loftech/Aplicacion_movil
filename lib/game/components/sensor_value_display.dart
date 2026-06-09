import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../../util/udp.dart';
import '../../globals/sensor_definitions.dart';

class SensorValueDisplay extends StatefulWidget {
  final SensorType sensorType;

  const SensorValueDisplay({super.key, required this.sensorType});

  @override
  State<SensorValueDisplay> createState() => _SensorValueDisplayState();
}

class _SensorValueDisplayState extends State<SensorValueDisplay> {
  // Mantenemos tu lógica de intervalos intacta
  double _computeInterval(double min, double max) {
    final range = (max - min).abs();

    if (range <= 20) return 2;
    if (range <= 50) return 5;
    if (range <= 100) return 10;
    if (range <= 200) return 20;
    if (range <= 500) return 50;
    if (range <= 1000) return 100;
    if (range <= 5000) return 500;

    return range / 10;
  }

  @override
  Widget build(BuildContext context) {
    final receiver = context.watch<UdpSensorReceiver>();
    final sensorInfo = getSensorInfo(context);
    final info = sensorInfo[widget.sensorType]!;
    final currentValue = receiver.latestValueOf(widget.sensorType) ?? 0;
    final isConnected = receiver.isSensorConnected(widget.sensorType);

    final min = info.limites[0];
    final max = info.limites[1];

    const double sweepDegrees = 240.0;
    const double startDegrees = 150.0;

    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(220, 220),
            painter: _RadialGaugePainter(
              min: min,
              max: max,
              value: currentValue,
              startDegrees: startDegrees,
              sweepDegrees: sweepDegrees,
              tickInterval: _computeInterval(min, max),
              unit: info.unidad,
            ),
          ),
          Positioned(
            bottom: 24,
            child: Text(
              isConnected
                  ? '${currentValue.toStringAsFixed(0)} ${info.unidad}'
                  : '--',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _RadialGaugePainter extends CustomPainter {
  final double min;
  final double max;
  final double value;
  final double startDegrees;
  final double sweepDegrees;
  final double tickInterval;
  final String unit;

  _RadialGaugePainter({
    required this.min,
    required this.max,
    required this.value,
    required this.startDegrees,
    required this.sweepDegrees,
    required this.tickInterval,
    required this.unit,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 12;

    final startAngle = (startDegrees - 90) * (math.pi / 180);
    final sweepAngle = sweepDegrees * (math.pi / 180);

    // Background arc
    final axisPaint = Paint()
      ..color = const Color(0xFFDFE2EC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      axisPaint,
    );

    // Ticks and labels
    final majorTickPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;
    final minorTickPaint = Paint()
      ..color = Colors.black26
      ..strokeWidth = 1.5;

    final labelStyle = TextStyle(color: Colors.black87, fontSize: 12);

    final totalSteps = ((max - min) / tickInterval).round();
    for (int i = 0; i <= totalSteps; i++) {
      final val = min + i * tickInterval;
      final t = (val - min) / (max - min);
      final angle = startAngle + t * sweepAngle;

      final outer = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      final inner = Offset(
        center.dx + math.cos(angle) * (radius - 12),
        center.dy + math.sin(angle) * (radius - 12),
      );

      canvas.drawLine(outer, inner, majorTickPaint);

      // Label
      final textPainter = TextPainter(
        text: TextSpan(text: val.round().toString(), style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      final labelOffset = Offset(
        center.dx + math.cos(angle) * (radius - 28) - textPainter.width / 2,
        center.dy + math.sin(angle) * (radius - 28) - textPainter.height / 2,
      );
      textPainter.paint(canvas, labelOffset);

      // minor ticks
      if (i < totalSteps) {
        for (int m = 1; m <= 4; m++) {
          final tMinor = t + (m / 5) * (1 / totalSteps);
          final angleMinor = startAngle + tMinor * sweepAngle;
          final outerMinor = Offset(
            center.dx + math.cos(angleMinor) * radius,
            center.dy + math.sin(angleMinor) * radius,
          );
          final innerMinor = Offset(
            center.dx + math.cos(angleMinor) * (radius - 8),
            center.dy + math.sin(angleMinor) * (radius - 8),
          );
          canvas.drawLine(outerMinor, innerMinor, minorTickPaint);
        }
      }
    }

    // Needle
    final tValue = ((value - min) / (max - min)).clamp(0.0, 1.0);
    final needleAngle = startAngle + tValue * sweepAngle;
    final needlePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final needleEnd = Offset(
      center.dx + math.cos(needleAngle) * (radius - 40),
      center.dy + math.sin(needleAngle) * (radius - 40),
    );
    canvas.drawLine(center, needleEnd, needlePaint);

    // Center knob
    canvas.drawCircle(center, 6, Paint()..color = Colors.black);

    // Target marker (value 50)
    final targetVal = (min + max) / 2 > 50 ? 50.0 : 50.0; // static 50 as before
    final tTarget = ((targetVal - min) / (max - min)).clamp(0.0, 1.0);
    final targetAngle = startAngle + tTarget * sweepAngle;
    final targetPoint = Offset(
      center.dx + math.cos(targetAngle) * (radius - 12),
      center.dy + math.sin(targetAngle) * (radius - 12),
    );
    final trianglePath = Path()
      ..moveTo(
        targetPoint.dx + math.cos(targetAngle) * 8,
        targetPoint.dy + math.sin(targetAngle) * 8,
      )
      ..lineTo(
        targetPoint.dx + math.cos(targetAngle + math.pi / 2) * 6,
        targetPoint.dy + math.sin(targetAngle + math.pi / 2) * 6,
      )
      ..lineTo(
        targetPoint.dx + math.cos(targetAngle - math.pi / 2) * 6,
        targetPoint.dy + math.sin(targetAngle - math.pi / 2) * 6,
      )
      ..close();
    canvas.drawPath(trianglePath, Paint()..color = Colors.red);
  }

  @override
  bool shouldRepaint(covariant _RadialGaugePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.min != min || oldDelegate.max != max;
  }
}
