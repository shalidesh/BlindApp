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


import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';


// late List<CameraDescription> cameras;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late stt.SpeechToText _speech;
  bool _isListening = false;
  FlutterTts ftts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var result1 = await ftts.speak("hi,how can i help you?");
      if (result1 == 1) {
        
        // Speaking
      } else {
        // Not speaking
      }
    _listen();
  });
  //   Future.delayed(Duration.zero, () async {
    
  // });
  
  }



//   void _listen() async {
//   if (!_isListening) {
//     bool available = await _speech.initialize(
//       onStatus: (val) => print('onStatus: $val'),
//       onError: (val) => print('onError: $val'),
//     );
//     if (available) {
//       setState(() => _isListening = true);
//       _speech.listen(
//         onResult: (val) => setState(() {
//           // Log the user's speech input to the console
//           print('User said: ${val.recognizedWords}');

//           if (val.recognizedWords.toLowerCase().contains("open the navigation")) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => Navigation()),
//             );
//           }
//           else if(val.recognizedWords.toLowerCase().contains("open the market")){

//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => SuperMarket()),
//             );

//           }
//            else if(val.recognizedWords.toLowerCase().contains("open the detector")){

//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ColorDetector()),
//             );

//           }
//         }),
//       );
//     }
//   } else {
//     setState(() => _isListening = false);
//     _speech.stop();
//   }
// }

void _listen() async {
  if (!_isListening) {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) {
          print('User said: ${val.recognizedWords}');
          // Check if the recognized words match the correct sentence
          if (val.recognizedWords.toLowerCase() == "navigation") {
            // Stop listening and perform any actions you want
            print("navigation called");
            setState(() => _isListening = false);
            _speech.stop();
            // ...
          } else {
            // Keep listening
            print("not correct command");
            _speech.listen(onResult: (val) {
              // Check if the recognized words match the correct sentence
              if (val.recognizedWords.toLowerCase() == "navigation") {
                // Stop listening and perform any actions you want
                print("keep listening called");
                print('User said: ${val.recognizedWords}');
                setState(() => _isListening = false);
                _speech.stop();
                // ...
              }
            });
          }
        },
      );
    }
  } else {
    setState(() => _isListening = false);
    _speech.stop();
  }
}




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


