import 'package:flutter/material.dart';
import 'package:caravana_enana/db/dwarf.dart';

class GenerateDwarvesScreen extends StatefulWidget {
  const GenerateDwarvesScreen({super.key});

  @override
  _GenerateDwarvesScreenState createState() => _GenerateDwarvesScreenState();
}

class _GenerateDwarvesScreenState extends State<GenerateDwarvesScreen> {
  String _generatedDwarf = '';
  Dwarf? _currentDwarf;

  Future<void> _generateDwarf() async {
    try {
      final dwarf = await DwarfTable.generateRandomDwarf();
      setState(() {
        _generatedDwarf = '${dwarf.name} ${dwarf.title}';
        _currentDwarf = dwarf;
      });
    } catch (e) {
      setState(() {
        _generatedDwarf = 'Error al generar enano: $e';
        _currentDwarf = null;
      });
    }
  }

  Future<void> _saveDwarf(BuildContext context) async {
    if (_currentDwarf != null) {
      try {
        await DwarfTable.insertDwarf(_currentDwarf!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enano guardado exitosamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el enano: $e')),
        );
        print('Error al guardar el enano: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay enano generado para guardar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar Enanos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                _generatedDwarf.isEmpty
                    ? 'Presiona el botón para generar un enano'
                    : 'Enano generado: $_generatedDwarf',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _generateDwarf,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Generar Enano'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _saveDwarf(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.save),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: GenerateDwarvesScreen(),
  ));
}