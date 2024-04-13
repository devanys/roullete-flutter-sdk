import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: RouletteController(),
  ));
}

class RouletteModel {
  final List<String> options;

  RouletteModel(this.options);

  String spinWheel() {
    final random = Random();
    final index = random.nextInt(options.length);
    return options[index];
  }
}

class RouletteController extends StatefulWidget {
  @override
  _RouletteControllerState createState() => _RouletteControllerState();
}

class _RouletteControllerState extends State<RouletteController> {
  late final RouletteModel _model;

  @override
  void initState() {
    super.initState();
    _model = RouletteModel([
      '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12',
      '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24',
      '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36',
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return RouletteView(
      options: _model.options,
      onSpin: (result) {
        // Do something with the result
        print("Result: $result");
      },
    );
  }
}

class RouletteView extends StatefulWidget {
  final List<String> options;
  final Function(String) onSpin;

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
