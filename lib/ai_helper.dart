import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class AIModelHelper {
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isLoaded = false;
  String? _loadError;

  Future<void> loadModel() async {
    if (_isLoaded) return;
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/food101_model.tflite');
      final raw = await rootBundle.loadString('assets/models/grad_ai_model.txt');
      _labels = raw.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      _isLoaded = true;
      _loadError = null;
    } catch (e) {
      _isLoaded = false;
      _loadError = e.toString();
    }
  }

  Future<Map<String, dynamic>> analyzeFood(Uint8List imageBytes) async {
    if (!_isLoaded) await loadModel();
    if (!_isLoaded || _interpreter == null) {
      return {'food_name': 'unknown', 'confidence': '0%', 'error': _loadError ?? 'Model failed to load'};
    }
    try {
      final rawImage = img.decodeImage(imageBytes);
      if (rawImage == null) return {'food_name': 'unknown', 'confidence': '0%', 'error': 'Could not decode image'};
      final resized = img.copyResize(rawImage, width: 224, height: 224);
      final input = Float32List(1 * 224 * 224 * 3);
      int idx = 0;
      for (int y = 0; y < 224; y++) {
        for (int x = 0; x < 224; x++) {
          final pixel = resized.getPixel(x, y);
          input[idx++] = pixel.r / 255.0;
          input[idx++] = pixel.g / 255.0;
          input[idx++] = pixel.b / 255.0;
        }
      }
      final inputTensor = input.reshape([1, 224, 224, 3]);
      final output = List.filled(101, 0.0).reshape([1, 101]);
      _interpreter!.run(inputTensor, output);
      final scores = List<double>.from(output[0] as List);
      int bestIdx = 0; double bestScore = scores[0];
      for (int i = 1; i < scores.length; i++) {
        if (scores[i] > bestScore) { bestScore = scores[i]; bestIdx = i; }
      }
      return {
        'food_name': bestIdx < _labels.length ? _labels[bestIdx] : 'unknown',
        'confidence': '${(bestScore * 100).toStringAsFixed(1)}%',
      };
    } catch (e) {
      return {'food_name': 'unknown', 'confidence': '0%', 'error': 'Analysis failed: ${e.toString()}'};
    }
  }

  bool get isLoaded => _isLoaded;
  String? get loadError => _loadError;
  void dispose() => _interpreter?.close();
}
