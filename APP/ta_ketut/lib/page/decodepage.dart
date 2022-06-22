import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;

import 'package:permission_handler/permission_handler.dart';

class DecodePage extends StatefulWidget {
  const DecodePage({Key? key}) : super(key: key);

  @override
  State<DecodePage> createState() => _DecodePageState();
}

class _DecodePageState extends State<DecodePage> {
  var _image;
  final picker = ImagePicker();
  var pickedFile;
  var _base64;
  var _isGranted = true;
  var ciphertext;
  var _ciphertext;
  var _decrypted;
  var key;
  var _key;
  String? filename;
  String _hasildek = 'Here The Password Appear';
  String? _resultdecode;
  final TextEditingController _mykeyController = TextEditingController();
  final TextEditingController _filenameController = TextEditingController();

  Future<Directory> get getExternalVisibleDir async {
    if (await Directory(
            '/storage/emulated/0/Android/data/com.example.ta_ketut/files/Download')
        .exists()) {
      final externalDir = Directory(
          '/storage/emulated/0/Android/data/com.example.ta_ketut/files/Download');
      return externalDir;
    } else {
      await Directory(
              '/storage/emulated/0/Android/data/com.example.ta_ketut/files/Download')
          .create(recursive: true);
      final externalDir = Directory(
          '/storage/emulated/0/Android/data/com.example.ta_ketut/files/Download');
      return externalDir;
    }
  }

  Future getImage() async {
    pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = Io.File(pickedFile.path);
        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _upload_d() async {
    Response response;
    var dio = Dio();
    if (_image == null) {
      print("No file chosen yet!");
    } else {
      try {
        final bytes = Io.File(pickedFile.path).readAsBytesSync();
        String img64 = base64Encode(bytes);
        response =
            await dio.post('https://ketutkusuma.pythonanywhere.com/decode',
                // 'http://10.0.2.2:5000/decode',
                data: {'img': img64}); //replace the URL
        if (response.statusCode == 200) {
          _base64 = response.data.toString();
          print('base64 :');
          print(_base64);
          _resultdecode = _base64;
          setState(() {
            _resultdecode = _base64;
          });
          _upload_decrypt(_resultdecode);
          // success();
        } else {
          print("Some Error Occurred!");
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future _upload_decrypt(_resultdecode) async {
    setState(() {
      _ciphertext = _resultdecode;
    });
    Response response;
    var dio = Dio();
    if (_ciphertext == null) {
      print("No text chosen yet!");
    } else {
      // final bytes = Io.File(pickedFile.path).readAsBytesSync();
      // String img64 = base64Encode(bytes);
      response =
          await dio.post('https://ketutkusuma.pythonanywhere.com/decrypt',
              // 'http://10.0.2.2:5000/decrypt',
              data: {'text': _ciphertext}); //replace the URL
      if (response.statusCode == 200) {
        _decrypted = response.data.toString();
        print(_decrypted);
        setState(() => _hasildek = _decrypted);
        _hasildek = _decrypted;
        // success();
      } else {
        print("Some Error Occurred!");
      }
    }
  }

  requestStoragePermission() async {
    if (!await Permission.storage.isGranted) {
      PermissionStatus result = await Permission.storage.request();
      if (result.isGranted) {
        setState(() {
          _isGranted = true;
        });
        _isGranted = true;
      } else {
        setState(() {
          _isGranted = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    requestStoragePermission();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2a4635),
        title: const Text(
          'Decode Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 80),
                  margin: EdgeInsets.only(top: 18),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        getImage();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 53, 130, 84),
                      ),
                      icon: Icon(Icons.image_rounded),
                      label: Text('Select Image'),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: _image == null
                              ? Text(
                                  'No image selected.',
                                )
                              : Image.file(
                                  _image!,
                                  height: 250.0,
                                  width: 250.0,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 80),
                  child: ElevatedButton(
                    onPressed: () {
                      _upload_d();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 53, 130, 84),
                    ),
                    child: Text('Decode Image To Get Password'),
                  ),
                ),
                Text(_hasildek),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Teks Kosong';
                      }
                      return null;
                    },
                    controller: _filenameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Masukan Nama File',
                      labelText: 'Filename',
                      // errorText: _validate ? 'value can\'t be empty' : null
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Teks Kosong';
                      } else if (text.length != 8) {
                        return 'harus sepanjang 8';
                      }
                      return null;
                    },
                    controller: _mykeyController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Masukan Password',
                      labelText: 'Password',
                      // errorText: _validate ? 'value can\'t be empty' : null
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: FloatingActionButton.extended(
                    heroTag: "btn1",
                    onPressed: () async {
                      if (_isGranted) {
                        Directory d = await getExternalVisibleDir;
                        setState(() {
                          filename = _filenameController.text;
                        });
                        setState(() {
                          key = _mykeyController.text;
                        });
                        setState(() {
                          _key = key + key;
                        });

                        _decryptAndCreate(d, filename, _key);
                      } else {
                        print('No permission Granted');

                        requestStoragePermission();
                      }
                    },
                    label: const Text(
                      'Decrypt Your Audio Here',
                      style: TextStyle(fontSize: 15),
                    ),
                    icon: const Icon(Icons.multitrack_audio_rounded),
                    elevation: 0,
                    backgroundColor: Color.fromARGB(255, 53, 130, 84),
                    highlightElevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _decryptAndCreate(Directory d, filename, key) async {
    try {
      Uint8List encData = await _readData(d.path + '/$filename');
      // Uint8List encData = await _readData('/storage/emulated/0/MyEncFolder/demo.mp4.aes');
      var plainData = await _decryptData(encData, key);
      String p = await _writeData(plainData, d.path + '/$filename.wav');
      // String p = await _writeData(plainData, '/storage/emulated/0/MyEncFolder/demo.mp4');
      print("file decrypted successfully: $p");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil deskripsi audio')));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  _decryptData(encData, key) {
    print("File decryption in progress...");
    print(key);
    var mykey = enc.Key.fromUtf8(key);
    final myIv = enc.IV.fromUtf8('ketutkusuma91020');
    final decr = enc.Encrypted(encData);
    final dec = enc.Encrypter(enc.AES(mykey));
    final decrypted = dec.decryptBytes(decr, iv: myIv);
    return decrypted;
  }

  Future<Uint8List> _readData(fileNameWithPath) async {
    print("Reading data...");
    File f = File(fileNameWithPath);
    return await f.readAsBytes();
  }

  Future<String> _writeData(dataToWrite, fileNameWithPath) async {
    print("Writting Data...");
    File f = File(fileNameWithPath);
    await f.writeAsBytes(dataToWrite);
    return f.absolute.toString();
  }
}
