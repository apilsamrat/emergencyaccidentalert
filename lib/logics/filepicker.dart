import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PickFile {
  late BuildContext context;
  pickFile({required BuildContext buildContext}) {
    context = buildContext;
  }

  Future<Uint8List?> pickImageWeb() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);
    return pickedFile!.files.first.bytes;
  }

  Future<String?> pickImageMobile() async {
    FilePickerResult? pickedFile =
        await FilePicker.platform.pickFiles(type: FileType.image);
    return pickedFile!.files.first.path;
  }

}
