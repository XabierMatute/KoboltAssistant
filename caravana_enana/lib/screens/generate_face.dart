import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

Future<void> generarCara(String cabezaPath, String ojosPath, String barbaPath, String sombreroPath, String salidaFileName) async {
  // Cargar las imágenes desde assets
  final cabezaBytes = await rootBundle.load(cabezaPath);
  final ojosBytes = await rootBundle.load(ojosPath);
  final barbaBytes = await rootBundle.load(barbaPath);
  final sombreroBytes = await rootBundle.load(sombreroPath);

  // Decodificar las imágenes
  img.Image cabeza = img.decodeImage(cabezaBytes.buffer.asUint8List())!;
  img.Image ojos = img.decodeImage(ojosBytes.buffer.asUint8List())!;
  img.Image barba = img.decodeImage(barbaBytes.buffer.asUint8List())!;
  img.Image sombrero = img.decodeImage(sombreroBytes.buffer.asUint8List())!;

  // Asegurarse de que las imágenes tengan el mismo tamaño
  ojos = img.copyResize(ojos, width: cabeza.width, height: cabeza.height);
  barba = img.copyResize(barba, width: cabeza.width, height: cabeza.height);
  sombrero = img.copyResize(sombrero, width: cabeza.width, height: cabeza.height);

  // Combinar las imágenes usando compositeImage
  img.compositeImage(cabeza, ojos);
  img.compositeImage(cabeza, barba);
  img.compositeImage(cabeza, sombrero);

  // Obtener el directorio temporal para guardar la imagen combinada
  final directory = await getTemporaryDirectory();
  final salidaPath = '${directory.path}/$salidaFileName';

  // Guardar la imagen combinada en el sistema de archivos local
  File(salidaPath).writeAsBytesSync(img.encodePng(cabeza));
  print('Imagen guardada en: $salidaPath');
}



class GenerateFaceScreen extends StatefulWidget {
  const GenerateFaceScreen({super.key});

  @override
  _GenerateFaceScreenState createState() => _GenerateFaceScreenState();
}

class _GenerateFaceScreenState extends State<GenerateFaceScreen> {
  List<String> _image1Paths = [];
  List<String> _image2Paths = [];
  List<String> _image3Paths = [];
  List<String> _image4Paths = [];
  int _image1Index = 0;
  int _image2Index = 0;
  int _image3Index = 0;
  int _image4Index = 0;
  String _outputPath = '';

Future<void> _generateFace() async {
  if (_image1Paths.isNotEmpty &&
      _image2Paths.isNotEmpty &&
      _image3Paths.isNotEmpty &&
      _image4Paths.isNotEmpty) {
    final cabezaPath = _image1Paths[_image1Index];
    final ojosPath = _image2Paths[_image2Index];
    final barbaPath = _image3Paths[_image3Index];
    final sombreroPath = _image4Paths[_image4Index];
    final salidaFileName = 'generated_face.png' + Random().nextInt(1000).toString() + '.png';

    await generarCara(cabezaPath, ojosPath, barbaPath, sombreroPath, salidaFileName);

    final directory = await getTemporaryDirectory();
    setState(() {
      _outputPath = '${directory.path}/$salidaFileName';
    });
  }
}

  @override
  void initState() {
    super.initState();
    _loadImagePaths();
  }

  Future<void> _loadImagePaths() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = Map<String, dynamic>.from(json.decode(manifestContent));

    setState(() {
      _image1Paths = manifestMap.keys
          .where((String key) => key.startsWith('assets/dwarf_image_generation/1_cabezas/'))
          .toList();
      _image2Paths = manifestMap.keys
          .where((String key) => key.startsWith('assets/dwarf_image_generation/2_ojos/'))
          .toList();
      _image3Paths = manifestMap.keys
          .where((String key) => key.startsWith('assets/dwarf_image_generation/3_barbas/'))
          .toList();
      _image4Paths = manifestMap.keys
          .where((String key) => key.startsWith('assets/dwarf_image_generation/4_sombreros/'))
          .toList();
    });
  }

  void _previousImage1() {
    setState(() {
      _image1Index = (_image1Index - 1 + _image1Paths.length) % _image1Paths.length;
    });
  }

  void _nextImage1() {
    setState(() {
      _image1Index = (_image1Index + 1) % _image1Paths.length;
    });
  }

  void _previousImage2() {
    setState(() {
      _image2Index = (_image2Index - 1 + _image2Paths.length) % _image2Paths.length;
    });
  }

  void _nextImage2() {
    setState(() {
      _image2Index = (_image2Index + 1) % _image2Paths.length;
    });
  }

  void _previousImage3() {
    setState(() {
      _image3Index = (_image3Index - 1 + _image3Paths.length) % _image3Paths.length;
    });
  }

  void _nextImage3() {
    setState(() {
      _image3Index = (_image3Index + 1) % _image3Paths.length;
    });
  }

  void _previousImage4() {
    setState(() {
      _image4Index = (_image4Index - 1 + _image4Paths.length) % _image4Paths.length;
    });
  }

  void _nextImage4() {
    setState(() {
      _image4Index = (_image4Index + 1) % _image4Paths.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar Cara'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        color: const Color(0xFF002A5C),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Image 1 + Image 2 + Image 3 + Image 4 = Output Image',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left),
                    onPressed: _previousImage1,
                  ),
                  Image.asset(
                    _image1Paths.isNotEmpty ? _image1Paths[_image1Index] : '',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: _nextImage1,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left),
                    onPressed: _previousImage2,
                  ),
                  Image.asset(
                    _image2Paths.isNotEmpty ? _image2Paths[_image2Index] : '',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: _nextImage2,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left),
                    onPressed: _previousImage3,
                  ),
                  Image.asset(
                    _image3Paths.isNotEmpty ? _image3Paths[_image3Index] : '',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: _nextImage3,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left),
                    onPressed: _previousImage4,
                  ),
                  Image.asset(
                    _image4Paths.isNotEmpty ? _image4Paths[_image4Index] : '',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: _nextImage4,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _outputPath.isNotEmpty
                  ? Image.file(
                      File(_outputPath),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.image,
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
                child: const Text('Generate'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _randomizeAndGenerate,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.casino, color: Colors.white),
      ),
    );
  }
  
  void _randomizeAndGenerate() {
    final random = Random();
    setState(() {
      _image1Index = random.nextInt(_image1Paths.length);
      _image2Index = random.nextInt(_image2Paths.length);
      _image3Index = random.nextInt(_image3Paths.length);
      _image4Index = random.nextInt(_image4Paths.length);
    });
    _generateFace();
  }
}