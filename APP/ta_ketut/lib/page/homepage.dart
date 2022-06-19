// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ta_ketut/page/encodepage.dart';

import 'decodepage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2a4635),
        title: const Text(
          'Home Page',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(
                    //   child: Icon(
                    //     Icons.phonelink_lock_outlined,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    Container(
                      // margin: const EdgeInsets.only(top: 200),
                      child: FloatingActionButton.extended(
                        heroTag: "btn1",
                        onPressed: () {
                          Navigator.pushNamed(context, '/halamanKetiga');
                        },
                        label: const Text(
                          'Encode',
                          style: TextStyle(fontSize: 20, letterSpacing: 4),
                        ),
                        icon: Icon(Icons.lock),
                        backgroundColor: Color.fromARGB(255, 53, 130, 84),
                        elevation: 0,
                        highlightElevation: 0,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: FloatingActionButton.extended(
                        heroTag: 'btn2',
                        onPressed: () {
                          Navigator.pushNamed(context, '/halamanKedua');
                        },
                        label: const Text(
                          'Decode',
                          style: TextStyle(fontSize: 20, letterSpacing: 4),
                        ),
                        icon: Icon(Icons.lock_open_rounded),
                        backgroundColor: Color.fromARGB(255, 0, 183, 94),
                        elevation: 0,
                        highlightElevation: 0,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
