import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:caravana_enana/db/name.dart';
import 'package:caravana_enana/db/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:caravana_enana/db/dwarf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:caravana_enana/image_generation/compose_image.dart'; // Importa composeImage
import 'package:image_picker/image_picker.dart'; // Importar ImagePicker para subir imágenes

class GenerateDwarvesScreen extends StatefulWidget {
  const GenerateDwarvesScreen({super.key});

  @override
  _GenerateDwarvesScreenState createState() => _GenerateDwarvesScreenState();
}


class _GenerateDwarvesScreenState extends State<GenerateDwarvesScreen> {
  String _generatedDwarf = '';
  Dwarf? _currentDwarf;
  String? _generatedImagePath;

  List<String> _cabezas = [];
  List<String> _ojos = [];
  List<String> _barbas = [];
  List<String> _sombreros = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAssets().then((_) => _generateDwarf()); // Cargar archivos y generar un enano

    _nameController.addListener(_updateGeneratedDwarfText);
    _titleController.addListener(_updateGeneratedDwarfText);
  }

  @override
  void dispose() {
    // Eliminar los listeners al destruir el widget
    _nameController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _updateGeneratedDwarfText() {
    setState(() {
      _generatedDwarf = '${_nameController.text} ${_titleController.text}';
    });
  }

  Future<void> _loadAssets() async {
    try {
      // Cargar las rutas de las imágenes desde el AssetManifest.json
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      setState(() {
        _cabezas = manifestMap.keys
            .where((String key) => key.startsWith('assets/dwarf_image_generation/1_cabezas/'))
            .toList();
        _ojos = manifestMap.keys
            .where((String key) => key.startsWith('assets/dwarf_image_generation/2_ojos/'))
            .toList();
        _barbas = manifestMap.keys
            .where((String key) => key.startsWith('assets/dwarf_image_generation/3_barbas/'))
            .toList();
        _sombreros = manifestMap.keys
            .where((String key) => key.startsWith('assets/dwarf_image_generation/4_sombreros/'))
            .toList();
      });
    } catch (e) {
      print('Error al cargar los archivos: $e');
    }
  }

  Future<void> _generateDwarf() async {
    try {
      final random = Random();

      // Seleccionar imágenes aleatorias
      final cabezaPath = _cabezas[random.nextInt(_cabezas.length)];
      final ojosPath = _ojos[random.nextInt(_ojos.length)];
      final barbaPath = _barbas[random.nextInt(_barbas.length)];
      final sombreroPath = _sombreros[random.nextInt(_sombreros.length)];

      // Cargar y decodificar las imágenes desde los assets
      final cabezaBytes = await rootBundle.load(cabezaPath);
      final ojosBytes = await rootBundle.load(ojosPath);
      final barbaBytes = await rootBundle.load(barbaPath);
      final sombreroBytes = await rootBundle.load(sombreroPath);

      final cabeza = img.decodeImage(cabezaBytes.buffer.asUint8List())!;
      final ojos = img.decodeImage(ojosBytes.buffer.asUint8List())!;
      final barba = img.decodeImage(barbaBytes.buffer.asUint8List())!;
      final sombrero = img.decodeImage(sombreroBytes.buffer.asUint8List())!;

      // Componer la imagen
      final composedImage = composeImage([cabeza, ojos, barba, sombrero]);

      // Guardar la imagen compuesta
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/generated_dwarf_${DateTime.now().millisecondsSinceEpoch}.png';
      File(imagePath).writeAsBytesSync(img.encodePng(composedImage));

      // Generar un enano aleatorio
      final dwarf = await DwarfTable.generateRandomDwarf();

      setState(() {
        _generatedDwarf = '${dwarf.name} ${dwarf.title}';
        _currentDwarf = Dwarf(
          id: dwarf.id,
          name: dwarf.name,
          title: dwarf.title,
          photoPath: imagePath, // Asignar la ruta de la imagen al enano
        );
        _nameController.text = dwarf.name; // Actualizar el controlador del nombre
        _titleController.text = dwarf.title; // Actualizar el controlador del título
        _generatedImagePath = imagePath;
      });
    } catch (e) {
      setState(() {
        _generatedDwarf = 'Error al generar enano: $e';
        _currentDwarf = null;
        _generatedImagePath = null;
      });
    }
  }
Future<void> _showImageOptionsDialog() async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Cara'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _generatedImagePath != null
                    ? Image.file(
                        File(_generatedImagePath!),
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.image,
                        size: 150,
                        color: Colors.grey,
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.upload_file, size: 40),
                      onPressed: () async {
                        Navigator.of(context).pop(); // Cierra el diálogo
                        await _pickImageFromGallery();
                      },
                      tooltip: 'Subir Imagen',
                    ),
                    IconButton(
                      icon: const Icon(Icons.casino, size: 40),
                      onPressed: () async {
                        await _updateDwarfImage();
                        setState(() {}); // Actualiza el estado del diálogo
                      },
                      tooltip: 'Generar Aleatoria',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _generatedImagePath = pickedFile.path;
      });
    }
  }

  Future<void> _saveDwarf(BuildContext context) async {
    if (_currentDwarf != null) {
      try {
        // Actualizar el nombre y el título del enano antes de guardarlo
        _currentDwarf = _currentDwarf!.copyWith(
          name: _nameController.text,
          title: _titleController.text,
          photoPath: _generatedImagePath, // Asegurarse de guardar la imagen actualizada
        );
  
        await DwarfTable.insertDwarf(_currentDwarf!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enano guardado exitosamente')),
        );
      } catch (e) {
        print('Error al guardar el enano: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el enano: $e')),
        );
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
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveDwarf(context),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _showImageOptionsDialog,
                    child: _generatedImagePath != null
                        ? Image.file(
                            File(_generatedImagePath!),
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.image,
                            size: 200,
                            color: Colors.grey,
                          ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _generatedDwarf.isEmpty
                        ? 'Generando un enano...'
                        : '$_generatedDwarf',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre del Enano',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.casino),
                        onPressed: () async {
                          final randomName = await _generateRandomName();
                          setState(() {
                            _nameController.text = randomName;
                          });
                        },
                        tooltip: 'Generar Nombre Aleatorio',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Título del Enano',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.casino),
                        onPressed: () async {
                          final randomTitle = await _generateRandomTitle();
                          setState(() {
                            _titleController.text = randomTitle;
                          });
                        },
                        tooltip: 'Generar Título Aleatorio',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateDwarf,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.refresh),
      ),
    );
  }

Future<String> _generateRandomName() async {
  final names = await NameTable.getNames(); // Obtén los nombres de la base de datos
  final random = Random();
  return names[random.nextInt(names.length)].name;
}

Future<String> _generateRandomTitle() async {
  final titles = await TitleTable.getTitles(); // Obtén los títulos de la base de datos
  final random = Random();
  return titles[random.nextInt(titles.length)].name;
}

Future<void> _updateDwarfImage() async {
  try {
    final random = Random();

    // Seleccionar imágenes aleatorias
    final cabezaPath = _cabezas[random.nextInt(_cabezas.length)];
    final ojosPath = _ojos[random.nextInt(_ojos.length)];
    final barbaPath = _barbas[random.nextInt(_barbas.length)];
    final sombreroPath = _sombreros[random.nextInt(_sombreros.length)];

    // Cargar y decodificar las imágenes desde los assets
    final cabezaBytes = await rootBundle.load(cabezaPath);
    final ojosBytes = await rootBundle.load(ojosPath);
    final barbaBytes = await rootBundle.load(barbaPath);
    final sombreroBytes = await rootBundle.load(sombreroPath);

    final cabeza = img.decodeImage(cabezaBytes.buffer.asUint8List())!;
    final ojos = img.decodeImage(ojosBytes.buffer.asUint8List())!;
    final barba = img.decodeImage(barbaBytes.buffer.asUint8List())!;
    final sombrero = img.decodeImage(sombreroBytes.buffer.asUint8List())!;

    // Componer la imagen
    final composedImage = composeImage([cabeza, ojos, barba, sombrero]);

    // Guardar la imagen compuesta
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/generated_dwarf_${DateTime.now().millisecondsSinceEpoch}.png';
    File(imagePath).writeAsBytesSync(img.encodePng(composedImage));

    // Actualizar solo la imagen y el _currentDwarf
    setState(() {
      _generatedImagePath = imagePath;
      if (_currentDwarf != null) {
        _currentDwarf = _currentDwarf!.copyWith(photoPath: imagePath);
      }
    });
  } catch (e) {
    setState(() {
      _generatedDwarf = 'Error al actualizar la imagen: $e';
      _generatedImagePath = null;
    });
}
  try {
    final random = Random();

    // Seleccionar imágenes aleatorias
    final cabezaPath = _cabezas[random.nextInt(_cabezas.length)];
    final ojosPath = _ojos[random.nextInt(_ojos.length)];
    final barbaPath = _barbas[random.nextInt(_barbas.length)];
    final sombreroPath = _sombreros[random.nextInt(_sombreros.length)];

    // Cargar y decodificar las imágenes desde los assets
    final cabezaBytes = await rootBundle.load(cabezaPath);
    final ojosBytes = await rootBundle.load(ojosPath);
    final barbaBytes = await rootBundle.load(barbaPath);
    final sombreroBytes = await rootBundle.load(sombreroPath);

    final cabeza = img.decodeImage(cabezaBytes.buffer.asUint8List())!;
    final ojos = img.decodeImage(ojosBytes.buffer.asUint8List())!;
    final barba = img.decodeImage(barbaBytes.buffer.asUint8List())!;
    final sombrero = img.decodeImage(sombreroBytes.buffer.asUint8List())!;

    // Componer la imagen
    final composedImage = composeImage([cabeza, ojos, barba, sombrero]);

    // Guardar la imagen compuesta
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/generated_dwarf_${DateTime.now().millisecondsSinceEpoch}.png';
    File(imagePath).writeAsBytesSync(img.encodePng(composedImage));

    // Actualizar solo la imagen
    setState(() {
      _generatedImagePath = imagePath;
    });
  } catch (e) {
    setState(() {
      _generatedDwarf = 'Error al actualizar la imagen: $e';
      _generatedImagePath = null;
    });
  }
  }
}