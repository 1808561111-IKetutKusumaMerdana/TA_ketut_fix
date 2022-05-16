import 'package:flutter/material.dart';
import 'package:ta_ketut/page/decodepage.dart';
import 'package:ta_ketut/page/encodepage.dart';
import 'package:ta_ketut/page/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/halamanPertama',
      routes: {
        '/halamanPertama': (context) => const HomePage(),
        '/halamanKedua': (context) => const DecodePage(),
        '/halamanKetiga': (context) => const EncodePage()
      },
    );
  }
}
