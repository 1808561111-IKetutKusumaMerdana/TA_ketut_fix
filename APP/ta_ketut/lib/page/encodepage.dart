import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ta_ketut/utils/filepicker_service.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';

import '../utils/save_page.dart';

class EncodePage extends StatefulWidget {
  const EncodePage({Key? key}) : super(key: key);

  @override
  State<EncodePage> createState() => _EncodePageState();
}

class _EncodePageState extends State<EncodePage> {
  bool _isGranted = true;
  String filename = "encrypt";
  late String _key;
  late String key;
  var _path;
  final FilePickerService _filePickerService = FilePickerService();
  TextEditingController fileNameController = TextEditingController();
  final TextEditingController _mykeyController = TextEditingController();
  final picker = ImagePicker();
  Widget? image;
  Io.File? _image;
  // ignore: prefer_typing_uninitialized_variables
  var pickedFile;
  var _base64;
  late String _plaintext;
  TextEditingController plaintext = TextEditingController();
  var secret;
  String? _resultenc;
  final _formKey = GlobalKey<FormState>();

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

  Future success() async {
    Fluttertoast.showToast(
        msg: "Successfully Encoded the Image!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIos: 3,
        backgroundColor: Color.fromARGB(255, 53, 130, 84),
        textColor: Colors.white,
        fontSize: 16.0);
    print("ABOUT TO");
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SavePage(imgbyte: _base64)));
  }

  Future _upload_e(String _resultenc) async {
    Response response;
    var dio = Dio();
    if (_image == null) {
      print("No file chosen yet!");
    } else {
      try {
        final bytes = Io.File(pickedFile.path).readAsBytesSync();
        String img64 = base64Encode(bytes);
        response =
            await dio.post('https://ketutkusuma.pythonanywhere.com/encode',
                // 'http://10.0.2.2:5000/encode',
                data: {'text': _resultenc, 'img': img64}); //replace the URL
        if (response.statusCode == 200) {
          _base64 = response.data.toString();
          print(_base64);
          success();
        } else {
          print("Some Error Occurred!");
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future _upload_encrypt() async {
    print("Encrypt password ... ");
    setState(() {
      _plaintext = _mykeyController.text;
    });
    Response response;
    var dio = Dio();
    if (_plaintext == null) {
      print("No text chosen yet!");
    } else {
      // final bytes = Io.File(pickedFile.path).readAsBytesSync();
      // String img64 = base64Encode(bytes);
      response =
          await dio.post('https://ketutkusuma.pythonanywhere.com/encrypt',
              // 'http://10.0.2.2:5000/encrypt',
              data: {'text': _plaintext}); //replace the URL
      if (response.statusCode == 200) {
        var _encrypted = response.data.toString();
        print('encrypted pass: ');
        print(_encrypted);
        setState(() {
          _resultenc = _encrypted;
        });
        _resultenc = _encrypted;
        _upload_e(_resultenc!);
        // success();
      } else {
        print("Some Error Occurred!");
      }
    }
  }

  void selectAudio() async {
    var audioData = await _filePickerService.audioFilePickAsBytes();
    print(audioData);

    if (audioData != null) {
      setState(() {
        _path = audioData;
      });
    } else {
      setState(() {});
    }
  }

  // requestStoragePermission() async {
  //   if (!await Permission.storage.isGranted) {
  //     PermissionStatus result = await Permission.storage.request();
  //     if (result.isGranted) {
  //       setState(() {
  //         _isGranted = true;
  //       });
  //     } else {
  //       setState(() {
  //         _isGranted = false;
  //       });
  //     }
  //   }
  // }
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
          'Encode Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  margin: const EdgeInsets.only(top: 18),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      onPressed: selectAudio,
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 53, 130, 84),
                      ),
                      label: const Text(
                        'Select Audio',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      icon: const Icon(Icons.audio_file_rounded),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: _image == null
                              ? const Text(
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
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  margin: const EdgeInsets.only(top: 18),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                        onPressed: () {
                          getImage();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 53, 130, 84),
                        ),
                        icon: const Icon(Icons.image_rounded),
                        label: const Text(
                          'Select Image',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Container(
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
                        labelText: 'Key',
                        // errorText: _validate ? 'value can\'t be empty' : null
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  height: 45,
                  margin: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_isGranted) {
                        if (_formKey.currentState!.validate()) {
                          Directory d = await getExternalVisibleDir;

                          setState(() => _key = _mykeyController.text);
                          setState(() => key = _key + _key);

                          _encryptAndCreate(_path, d, filename, key);
                          _upload_encrypt();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Berhasil enkripsi audio')));
                          // TODO submit
                        }
                      } else {
                        print('no permission granted');
                        requestStoragePermission();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 53, 130, 84),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Text(
                      'Encrypt Audio',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_encryptAndCreate(Uint8List path, Directory d, filename, _mykey) async {
  if (path != null) {
    print("Data Loading. . . ");
    var resp = path;

    var encResult = _encryptData(resp, _mykey);
    String p = await _writeData(encResult, d.path + '/$filename.aes');
    // String p = await _writeData(encResult, '/storage/emulated/0/MyEncFolder/demo.mp4.aes');
    print("file encrypted successfully: $p");
  } else {
    print("Null file");
  }
}

_encryptData(plainString, mykey) {
  print("Encrypting File...");
  print(mykey);
  var _mykey = enc.Key.fromUtf8(mykey);
  final encr = enc.Encrypter(enc.AES(_mykey));
  final myIv = enc.IV.fromUtf8('ketutkusuma91020');
  final encrypted = encr.encryptBytes(plainString, iv: myIv);
  // MyEncrypt.myEncrypter.encryptBytes(plainString, iv: MyEncrypt.myIv);
  return encrypted.bytes;
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
