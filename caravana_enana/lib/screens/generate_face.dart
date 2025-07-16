import 'package:flutter/material.dart';

class GenerateFaceScreen extends StatefulWidget {
  const GenerateFaceScreen({super.key});

  @override
  _GenerateFaceScreenState createState() => _GenerateFaceScreenState();
}

class _GenerateFaceScreenState extends State<GenerateFaceScreen> {
  String? _generatedFacePath;

  void _generateFace() {
    setState(() {
      // Prototipo: Muestra una imagen fija desde los assets
      _generatedFacePath = 'assets/dwarf_image_generation/caras/cara_sabe cosas.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar Cara'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _generatedFacePath != null
              ? Image.asset(
                  _generatedFacePath!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                )
              : const Icon(
                  Icons.face,
                  size: 100,
                  color: Colors.grey,
                ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _generateFace,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Generar Cara'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: GenerateFaceScreen(),
  ));
}