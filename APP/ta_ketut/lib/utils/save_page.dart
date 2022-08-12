import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:core';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';
import 'package:ta_ketut/page/homepage.dart';

class SavePage extends StatefulWidget {
  final String imgbyte;
  SavePage({Key? key, required this.imgbyte});
  @override
  _SavePage createState() => _SavePage();
}

class _SavePage extends State<SavePage> {
  Future<List<Directory>?> _getExternalStoragePath() {
    return getExternalStorageDirectories(type: StorageDirectory.downloads);
  }

  Future<Directory> get getExternalVisibleDir async {
    if (await Directory('/storage/emulated/0/MyEncFolder').exists()) {
      final externalDir = Directory('/storage/emulated/0/MyEncFolder');
      return externalDir;
    } else {
      await Directory('/storage/emulated/0/MyEncFolder')
          .create(recursive: true);
      final externalDir = Directory('/storage/emulated/0/MyEncFolder');
      return externalDir;
    }
  }

  late String _fileFullPath;
  bool _isGranted = true;

  requestStoragePermission() async {
    if (!await Permission.storage.isGranted) {
      PermissionStatus result = await Permission.storage.request();
      if (result.isGranted) {
        setState(() {
          _isGranted = true;
        });
      } else {
        setState(() {
          _isGranted = false;
        });
      }
    }
  }

  Future _writeExternalStorage(Uint8List bytes) async {
    // final dirList = await _getExternalStoragePath();
    // final path = dirList![0].path;
    final path = await getExternalVisibleDir;
    // final file = File('$path/Stego.png');
    final file = File('${path.path}/Stego.png');

    // print(file);
    // String filename = file.path.split('/').last;
    // print(filename);

    file.writeAsBytes(bytes).then((File _file) {});
  }

  @override
  Widget build(BuildContext context) {
    requestStoragePermission();
    Uint8List bytes = const Base64Codec().decode(widget.imgbyte);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Result Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2a4635),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: const EdgeInsets.all(12.0),
                height: 450.0,
                width: 350.0,
                child: Image.memory(bytes),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      primary: const Color.fromARGB(255, 53, 130, 84),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      _writeExternalStorage(bytes);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Berhasil menyimpan')));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Save Image',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
