import 'dart:typed_data';

import 'package:tarot_app/model/result.dart';

class Capture{
  Result? result;
  Uint8List? imageFile;

  Capture({
    required this.result,
    required this.imageFile
  });

}