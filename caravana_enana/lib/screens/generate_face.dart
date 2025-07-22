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
  String _image1Path = 'assets/dwarf_image_generation/1_cabezas/cabeza1.png';
  String _image2Path = 'assets/dwarf_image_generation/2_ojos/ojo1.png';
  String _image3Path = 'assets/dwarf_image_generation/3_barbas/barba1.png';
  String _image4Path = 'assets/dwarf_image_generation/4_sombreros/sombrero1.png';
  String _outputPath = '';

  Future<String> _getRandomImagePath(String folderPath) async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = Map<String, dynamic>.from(json.decode(manifestContent));
    final List<String> imagePaths = manifestMap.keys
        .where((String key) => key.startsWith(folderPath))
        .toList();
    final random = Random();
    return imagePaths[random.nextInt(imagePaths.length)];
  }

  void _changeImage1() async {
    final newPath = await _getRandomImagePath('assets/dwarf_image_generation/1_cabezas/');
    setState(() {
      _image1Path = newPath;
    });
  }

  void _changeImage2() async {
    final newPath = await _getRandomImagePath('assets/dwarf_image_generation/2_ojos/');
    setState(() {
      _image2Path = newPath;
    });
  }

  void _changeImage3() async {
    final newPath = await _getRandomImagePath('assets/dwarf_image_generation/3_barbas/');
    setState(() {
      _image3Path = newPath;
    });
  }

  void _changeImage4() async {
    final newPath = await _getRandomImagePath('assets/dwarf_image_generation/4_sombreros/');
    setState(() {
      _image4Path = newPath;
    });
  }

  void _generateFace() async {
    int randomIndex = Random().nextInt(1000);
    final salidaFileName = 'cara_combinada_$randomIndex.png';
    print('Generando cara con $_image1Path, $_image2Path, $_image3Path y $_image4Path');
    await generarCara(_image1Path, _image2Path, _image3Path, _image4Path, salidaFileName);
    final directory = await getTemporaryDirectory();
    setState(() {
      _outputPath = '${directory.path}/$salidaFileName';
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
        //cobalt blue
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
                  Image.asset(
                    _image1Path,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _changeImage1,
                    child: const Text('Change'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    _image2Path,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _changeImage2,
                    child: const Text('Change'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    _image3Path,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _changeImage3,
                    child: const Text('Change'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    _image4Path,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _changeImage4,
                    child: const Text('Change'),
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
    );
  }
}