import 'package:bindappp/ColorDetector.dart';
import 'package:bindappp/Navigation.dart';
import 'package:bindappp/SuperMarkets.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:bindappp/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:async';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:image_picker/image_picker.dart';


// late List<CameraDescription> cameras;

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
        body: Container(
          color: Colors.grey[200],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Open the
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Navigation()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 100.0,
                      color: Colors.green,
                      child: const Center(
                        child:
                            Text("Navigation", style: TextStyle(fontSize: 25)),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Open the
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SuperMarket()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 100.0,
                      color: Colors.green,
                      child:
                          const Center(child:
                              Text("Super Market", style:
                                  TextStyle(fontSize:
                                      25)),
                          ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Open the
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder:
                          (context) => ColorDetector()),
                    );
                    print('logged');
                  },
                  child:
                      Padding(padding:
                          const EdgeInsets.all(8.0),
                          child:
                              Container(width:
                                  double.infinity,
                                  height:
                                      100.0,
                                  color:
                                      Colors.green,
                                  child:
                                      const Center(child:
                                          Text("Color Detector",
                                              style:
                                                  TextStyle(fontSize:
                                                      25)),
                                          ),
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


