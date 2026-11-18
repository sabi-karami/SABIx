import 'dart:math' as math;

import 'package:flutter/material.dart';

class SabixOrbitPainter extends CustomPainter {
  SabixOrbitPainter(this.motion, this.signal, this.muted) : super(repaint: motion);
  final Animation<double> motion;
  final Color signal;
  final Color muted;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final u = math.min(size.width, size.height) / 300;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(u);
    final grid = Paint()..color = muted.withValues(alpha: .13);
    for (var n = -6; n <= 6; n++) {
      final x = n * 22.0;
      canvas.drawLine(Offset(x, -146), Offset(x, 146), grid);
      canvas.drawLine(Offset(-146, x), Offset(146, x), grid);
    }
    final tint = Paint()..shader = RadialGradient(colors: [signal.withValues(alpha: .09), signal.withValues(alpha: 0)]).createShader(const Rect.fromLTWH(-115, -115, 230, 230));
    canvas.drawCircle(Offset.zero, 115, tint);
    final outline = Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = muted.withValues(alpha: .36);
    canvas.drawCircle(Offset.zero, 124, outline);
    canvas.drawCircle(Offset.zero, 102, outline);
    final bright = Paint()..style = PaintingStyle.stroke..color = signal..strokeCap = StrokeCap.round..strokeWidth = 2;
    canvas.save();
    canvas.rotate(-math.pi / 5 + motion.value * 2 * math.pi);
    canvas.drawOval(const Rect.fromLTWH(-110, -42, 220, 84), outline..color = signal.withValues(alpha: .65));
    canvas.drawCircle(const Offset(110, 0), 9, bright);
    canvas.drawCircle(const Offset(110, 0), 3, Paint()..color = signal);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(SabixOrbitPainter oldDelegate) => oldDelegate.motion != motion || oldDelegate.signal != signal || oldDelegate.muted != muted;
}
