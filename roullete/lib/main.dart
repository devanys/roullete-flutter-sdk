import 'dart:async';
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
      '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12',
      '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24',
      '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35',
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return RouletteView(
      options: _model.options,
      onSpin: (output) { // Mengubah parameter menjadi "output"
        // Do something with the output
        print("Output: $output"); // Mengubah kata "result" menjadi "output"
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

class _RouletteViewState extends State<RouletteView> with SingleTickerProviderStateMixin {
  late final RouletteModel _model;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late String _output = "Spin Of Fortune!"; // Mengubah kata "result" menjadi "output"

  @override
  void initState() {
    super.initState();
    _model = RouletteModel(widget.options);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // Durasi putaran, dapat diubah sesuai kebutuhan
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        final String output = _model.spinWheel(); // Mengubah nama variabel menjadi "output"
        setState(() {
          _output = output; // Mengubah nama variabel menjadi "output"
        });
        widget.onSpin(output); // Mengubah kata "result" menjadi "output"
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _spinWheel() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UTS'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _animation,
              child: GestureDetector(
                onTap: _spinWheel,
                child: Container(
                  width: 280, 
                  height: 280, 
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: ClipOval(
                    child: Container(
                      width: 280, 
                      height: 280, 
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
              'Output: $_output', // Mengubah kata "result" menjadi "output"
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
      if (options[i] == '0') {
        canvas.drawArc(
          Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
          i * angle * pi / 180,
          angle * pi / 180,
          true,
          paint..color = Colors.green, // Memberikan warna hijau untuk angka 0
        );
      } else {
        canvas.drawArc(
          Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
          i * angle * pi / 180,
          angle * pi / 180,
          true,
          paint..color = i.isEven ? Colors.red : Colors.black,
        );
      }
      _drawText(canvas, size, options[i], i * angle, angle);
    }

    canvas.restore();
  }

  void _drawText(Canvas canvas, Size size, String text, double startAngle, double sweepAngle) {
    final double radius = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final double radians = (startAngle + sweepAngle / 2) * pi / 180;

    final double x = centerX + (radius - 9) * cos(radians); // Penyesuaian posisi teks ke atas
    final double y = centerY + (radius - 9) * sin(radians); // Penyesuaian posisi teks ke atas dua kali

    final double textRotation = (startAngle + sweepAngle / 2 - 90) * pi / 180; // Rotasi teks agar sejajar dengan roda

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: text == '0' ? Colors.white : Colors.white, // Angka 0 berwarna hijau, angka lainnya putih
          fontSize: 14,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(textRotation);
    textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(RoulettePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(RoulettePainter oldDelegate) => false;
}
