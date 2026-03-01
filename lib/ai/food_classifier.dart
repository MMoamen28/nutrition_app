import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

class FoodClassifier {
  late Interpreter _interpreter;
  late List<String> labels;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/models/food101_model.tflite',
    );

    final labelData = await rootBundle.loadString(
      'assets/models/grad_ai_model.txt',
    );
    labels = labelData.split('\n');
  }

  String predict(img.Image image) {
    final input = _preprocess(image);

    final output = List.filled(101, 0.0).reshape([1, 101]);

    _interpreter.run(input, output);

    final scores = output[0];
    int maxIndex = scores.indexOf(scores.reduce((a, b) => a > b ? a : b));

    return labels[maxIndex];
  }

  Float32List _preprocess(img.Image image) {
    final resized = img.copyResize(image, width: 224, height: 224);

    final buffer = Float32List(1 * 224 * 224 * 3);
    int index = 0;

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resized.getPixel(x, y);

        buffer[index++] = pixel.r / 255.0;
        buffer[index++] = pixel.g / 255.0;
        buffer[index++] = pixel.b / 255.0;
      }
    }

    return buffer;
  }
}
