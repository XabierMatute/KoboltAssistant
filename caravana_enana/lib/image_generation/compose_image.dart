import 'package:image/image.dart' as img;

img.Image composeImage(List<img.Image> images) {
  if (images.isEmpty) {
    throw ArgumentError('No images provided for composition.');
  }

  img.Image compositeImage = images[0];

  for (int i = 1; i < images.length; i++) {
    compositeImage = img.compositeImage(compositeImage, images[i]);
  }

  return compositeImage;
}