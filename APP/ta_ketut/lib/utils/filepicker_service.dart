import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';

class FilePickerService {
  Future<File?> audioFilePickAsBytes() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['wav', 'aes']);

    if (result != null) {
      File file = File(result.files.single.path!);

      print(file.readAsString());
      return file;
    } else {
      return null;
    }
  }
}

// class PathPickerService {
//   Future<Path> pathPicker() async {
//     FilePickerResult result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['wav', 'aes']);

//     if (result != null) {
//       PlatformFile file = result.files.first;
//       print(file.path);
//       // File file = File(result.files.single.path);
//       // print(file.readAsString());
//       // return file;
//     } else {
//       return null;
//     }
//   }
// }
