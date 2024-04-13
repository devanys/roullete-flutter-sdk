import 'dart:math';
import 'package:flutter/material.dart';
import 'package:roullete/model.dart';

class RouletteView extends StatefulWidget {
  final List<String> options;
  final Function(String) onSpin; // Perhatikan tipe data parameter di sini

  RouletteView({required this.options, required this.onSpin});

  @override
  _RouletteViewState createState() => _RouletteViewState();
}

class _RouletteViewState extends State<RouletteView> {
  late final RouletteModel _model;
  late String _result = "Spin the wheel!";

  @override
  void initState() {
    super.initState();
    _model = RouletteModel(widget.options);
  }

  void _spinWheel() {
    final String result = _model.spinWheel();
    setState(() {
      _result = result;
    });
    widget.onSpin(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roulette Wheel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotatedBox(
              quarterTurns: 1,
              child: GestureDetector(
                onTap: _spinWheel,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: ClipOval(
                    child: Container(
                      width: 200,
                      height: 200,
                      color: Colors.white,
                      child: CustomPaint(
                        painter: RoulettePainter(widget.options),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Result: $_result',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class RoulettePainter extends CustomPainter {
  final List<String> options;
  final double degrees = 360;

  RoulettePainter(this.options);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.red;
    final double angle = degrees / options.length;

    canvas.save();

    for (int i = 0; i < options.length; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
        i * angle * pi / 180,
        angle * pi / 180,
        true,
        paint..color = i.isEven ? Colors.red : Colors.black,
      );
      _drawText(canvas, size, options[i], i * angle, angle);
    }

    canvas.restore();
  }

  void _drawText(Canvas canvas, Size size, String text, double startAngle, double sweepAngle) {
    final double radius = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final double radians = (startAngle + sweepAngle / 2) * pi / 180;

    final double x = centerX + radius * cos(radians);
    final double y = centerY + radius * sin(radians);

    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: Colors.white, fontSize: 16)),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(RoulettePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(RoulettePainter oldDelegate) => false;
}
