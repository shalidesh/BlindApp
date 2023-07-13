import 'package:bindappp/camerscreen.dart';
import 'package:flutter/material.dart';

import 'CameraScreenTest.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Blind App"),
          backgroundColor: Colors.orangeAccent,
        ),
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Open the
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CameraScreenTest()),
                );
                print('logged');
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 100.0,
                  color: Colors.green,
                  child:
                      const Text("Navigation", style: TextStyle(fontSize: 25)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 100.0,
                color: Colors.green,
                child:
                    const Text("Super Market", style: TextStyle(fontSize: 25)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 100.0,
                color: Colors.green,
                child: const Text("Dress Color Detect",
                    style: TextStyle(fontSize: 25)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
