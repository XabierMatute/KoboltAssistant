// python reference code 
//import os
// import random
// from PIL import Image

// def generar_cara(cabeza_path, ojos_path, salida_path):
//     # Abrir las imágenes
//     cabeza = Image.open(cabeza_path)
//     ojos = Image.open(ojos_path)

//     # Asegurarse de que las imágenes tengan el mismo tamaño
//     ojos = ojos.resize(cabeza.size)

//     # Combinar las imágenes
//     cabeza.paste(ojos, (0, 0), ojos)

//     # Guardar la imagen combinada
//     cabeza.save(salida_path)

import 'dart:io';
import 'package:image/image.dart' as img;

Future<void> generarCara(String cabezaPath, String ojosPath, String salidaPath) async {
  // Cargar las imágenes
  img.Image cabeza = img.decodeImage(File(cabezaPath).readAsBytesSync())!;
  img.Image ojos = img.decodeImage(File(ojosPath).readAsBytesSync())!;

  // Asegurarse de que las imágenes tengan el mismo tamaño
  ojos = img.copyResize(ojos, width: cabeza.width, height: cabeza.height);

  // Combinar las imágenes usando copyInto
  img.compositeImage(cabeza, ojos, dstX: 0, dstY: 0);

  // Guardar la imagen combinada
  File(salidaPath).writeAsBytesSync(img.encodePng(cabeza));
}