import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import '../ai/food_classifier.dart';

class FoodAiScreen extends StatefulWidget {
  const FoodAiScreen({super.key});

  @override
  State<FoodAiScreen> createState() => _FoodAiScreenState();
}

class _FoodAiScreenState extends State<FoodAiScreen> {
  final picker = ImagePicker();
  final classifier = FoodClassifier();

  String result = "No food detected";

  @override
  void initState() {
    super.initState();
    classifier.loadModel();
  }

  Future<void> pickImage() async {
    final file = await picker.pickImage(source: ImageSource.camera);
    if (file == null) return;

    final bytes = File(file.path).readAsBytesSync();
    final image = img.decodeImage(bytes)!;

    final food = classifier.predict(image);

    setState(() {
      result = food;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Food AI")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(result, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: pickImage,
            child: const Text("Take Food Photo"),
          ),
        ],
      ),
    );
  }
}