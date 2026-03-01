import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

class FoodClassifier {
  late Interpreter _interpreter;
  late List<String> labels;

  /// Load the TFLite model and labels
  Future<void> loadModel() async {
    // Load the TFLite model from assets
    _interpreter = await Interpreter.fromAsset(
      'assets/models/food101_model.tflite',
    );

    // Load labels from grad_ai_model.txt
    final labelData = await rootBundle.loadString(
      'assets/models/grad_ai_model.txt',
    );

    // Split by line, trim whitespace, remove empty lines
    labels = labelData
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  /// Predict the food name from an image
  String predict(img.Image image) {
    final input = _preprocess(image);

    // Make sure the output shape matches your model: 101 classes
    final output = List.filled(101, 0.0).reshape([1, 101]);

    _interpreter.run(input, output);

    final scores = output[0] as List<double>;

    // Get index with highest probability
    int maxIndex = scores.indexOf(scores.reduce((a, b) => a > b ? a : b));

    // Return the food name from labels
    return labels[maxIndex];
  }

  /// Preprocess image into Float32List for TFLite input
  Float32List _preprocess(img.Image image) {
    // Resize to 224x224
    final resized = img.copyResize(image, width: 224, height: 224);

    final buffer = Float32List(1 * 224 * 224 * 3);
    int index = 0;

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resized.getPixel(x, y);

        // Correct methods from the 'image' package
        buffer[index++] = img.getRed(pixel) / 255.0;
        buffer[index++] = img.getGreen(pixel) / 255.0;
        buffer[index++] = img.getBlue(pixel) / 255.0;
      }
    }

    return buffer;
  }
}
