import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:core';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
    final dirList = await _getExternalStoragePath();
    final path = dirList![0].path;
    final file = File('$path/Stego.png');
    print(file);

    file.writeAsBytes(bytes).then((File _file) {});
  }

  @override
  Widget build(BuildContext context) {
    requestStoragePermission();
    Uint8List bytes = Base64Codec().decode(widget.imgbyte);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("The Steg Dog"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(12.0),
                height: 450.0,
                width: 350.0,
                child: Image.memory(bytes),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    primary: Colors.black,
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    _writeExternalStorage(bytes);
                  },
                  child: const Text('Save Image'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
