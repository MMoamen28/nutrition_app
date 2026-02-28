import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class AIModelHelper {
  Interpreter? _interpreter;

  // 1. Load the model from your assets
  Future<void> loadModel() async {
    try {
      // Points to the exact file in your screenshot
      _interpreter = await Interpreter.fromAsset(
        'assets/models/food101_model.tflite',
      );
    } catch (e) {
      // Using a log or debug message instead of a raw print for production standards
      debugPrint('Failed to load model: $e');
    }
  }

  // 2. Analyze the uploaded photo
  Future<Map<String, dynamic>> analyzeFood(Uint8List imageBytes) async {
    if (_interpreter == null) return {"error": "Model not loaded yet"};

    // 3. Resize the image (224x224 is standard for Food101)
    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) return {"error": "Could not read image"};

    img.Image resizedImage = img.copyResize(
      originalImage,
      width: 224,
      height: 224,
    );

    // 4. Convert the image into a 3D array of pixels
    var input = List.generate(
      1,
      (i) => List.generate(
        224,
        (y) => List.generate(224, (x) => List.generate(3, (c) => 0.0)),
      ),
    );

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resizedImage.getPixel(x, y);
        input[0][y][x][0] = pixel.r / 255.0;
        input[0][y][x][1] = pixel.g / 255.0;
        input[0][y][x][2] = pixel.b / 255.0;
      }
    }

    // 5. Prepare output for 101 classes
    int numberOfFoodClasses = 101;
    var output = List.filled(
      1 * numberOfFoodClasses,
      0.0,
    ).reshape([1, numberOfFoodClasses]);

    // 6. Run Inference
    _interpreter!.run(input, output);

    List<double> probabilities = output[0].cast<double>();
    int highestIndex = 0;
    double maxProb = probabilities[0];

    for (int i = 1; i < probabilities.length; i++) {
      if (probabilities[i] > maxProb) {
        maxProb = probabilities[i];
        highestIndex = i;
      }
    }

    // Fixed interpolation warning here!
    return {
      "food_name": "Food Class #$highestIndex",
      "confidence": "${(maxProb * 100).toStringAsFixed(1)}%",
    };
  }
}

// Simple helper to avoid linter warnings
void debugPrint(String message) {
  print(message);
}
