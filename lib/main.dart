import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'ai_helper.dart'; // Imports your new AI brain

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutrition App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const NutritionScreen(),
    );
  }
}

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  // 1. Initialize our AI Helper
  final AIModelHelper _aiHelper = AIModelHelper();

  Uint8List? _imageBytes;
  Map<String, dynamic>? _results;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    // 2. Load the model into memory the moment the app opens!
    _aiHelper.loadModel();
  }

  // 3. The function that runs when you tap the button
  Future<void> _pickAndAnalyzeImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image from the gallery
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
  // Read the image as bytes (this fixes the Web issue you had earlier!)
      final bytes = await image.readAsBytes();

      setState(() {
        _imageBytes = bytes;
        _isAnalyzing = true; // Show a loading spinner
        _results = null;
      });

      // 4. Pass the photo to the AI Model!
      final results = await _aiHelper.analyzeFood(bytes);

      setState(() {
        _results = results;
        _isAnalyzing = false; // Stop the loading spinner
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Nutrition Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Show the selected image, or a placeholder text
              if (_imageBytes != null)
                Image.memory(
                  _imageBytes!,
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                )
              else
                const Text('No food photo selected yet.'),

              const SizedBox(height: 30),

              // The Upload Button
              ElevatedButton.icon(
                onPressed: _pickAndAnalyzeImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text(
                  'Upload Meal & Analyze',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 30),

              // Show a loading spinner while the AI thinks, OR show the results!
              if (_isAnalyzing)
                const CircularProgressIndicator()
              else if (_results != null)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          "🍽️ ${_results!['food_name'] ?? 'Unknown'}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text("🔥 Calories: ${_results!['calories'] ?? 'N/A'}"),
                        Text("💪 Protein: ${_results!['protein'] ?? 'N/A'}"),
                        Text(
                          "🎯 AI Confidence: ${_results!['confidence'] ?? 'N/A'}",
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
