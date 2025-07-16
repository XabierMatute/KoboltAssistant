import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<void> generarCara(String cabezaPath, String ojosPath, String salidaFileName) async {
  // Cargar las imágenes desde assets
  final cabezaBytes = await rootBundle.load(cabezaPath);
  final ojosBytes = await rootBundle.load(ojosPath);

  // Decodificar las imágenes
  img.Image cabeza = img.decodeImage(cabezaBytes.buffer.asUint8List())!;
  img.Image ojos = img.decodeImage(ojosBytes.buffer.asUint8List())!;

  // Asegurarse de que las imágenes tengan el mismo tamaño
  ojos = img.copyResize(ojos, width: cabeza.width, height: cabeza.height);

  // Combinar las imágenes usando copyInto
  img.compositeImage(cabeza, ojos);

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
  String _image1Path = 'assets/dwarf_image_generation/1_cabezas/cabeza3.png';
  String _image2Path = 'assets/dwarf_image_generation/2_ojos/ojo4.png';
  String _outputPath = '';

  void _generateFace() async {
    final salidaFileName = 'cara_combinada.png';
    await generarCara(_image1Path, _image2Path, salidaFileName);
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Image 1 + Image 2 = Output Image',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Image.asset(
              _image1Path,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Image.asset(
              _image2Path,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
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
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: GenerateFaceScreen(),
  ));
}