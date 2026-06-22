import 'dart:typed_data';
import 'package:image/image.dart' as img;

class FoodClassifier {
  static Float32List preprocessImage(img.Image image) {
    final resized = img.copyResize(image, width: 224, height: 224);
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
    return input;
  }
}
