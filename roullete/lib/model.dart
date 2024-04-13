import 'dart:math';

class RouletteModel {
  final List<String> _options;

  RouletteModel(this._options);

  get options_ => null;

  String spinWheel() {
    final random = Random();
    final index = random.nextInt(_options.length);
    return _options[index];
  }
}
