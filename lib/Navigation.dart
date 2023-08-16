import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:bindappp/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:async';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:flutter_tts/flutter_tts.dart';


class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

  List<dynamic>? _recognitions;

  late CameraController controller;
  late FlutterVision vision;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  int _taps = 0;
  FlutterTts ftts = FlutterTts();
  bool isSpeaking = false;

  double CONFIDENCE_THRESHOLD = 0.4;
  double NMS_THRESHOLD = 0.3;

  //  Distance constants 
  double KNOWN_DISTANCE = 62; //INCHES
  double CHAIR_WIDTH = 21; //INCHES
  double TABLE_WIDTH = 33; //INCHES

  double chair_width_in_rf = 240.9855;
  double table_width_in_rf = 378.41183;

  double focal_chair=0.0;
  double focal_table=0.0;
  double distance=0.0;
  String distance_text='';

  @override
  void initState() {
    super.initState();
    initCamera();
    ftts.setCompletionHandler(() {
        setState(() {
          isSpeaking = false;
        });
      });

  }

  double focalLengthFinder(double measuredDistance, double realWidth, double widthInRf) {
    double focalLength = (widthInRf * measuredDistance) / realWidth;
    return focalLength;
}

double distanceFinder(double focalLength, double realObjectWidth, double widthInFrame) {
    double distance = (realObjectWidth * focalLength) / widthInFrame;
    return distance;
}

  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
        labels: 'assets/navigation_2.txt',
        modelPath: 'assets/navigation_2.tflite',
        modelVersion: "yolov5",
        numThreads: 2,
        useGpu: false);
    setState(() {
      isLoaded = true;
    });

  }

  initCamera() async {
    final cameras = await availableCameras();
    vision = FlutterVision();
    controller = CameraController(cameras[0], ResolutionPreset.low);
    controller.initialize().then((value) {
      loadYoloModel().then((value) {

        focal_chair = focalLengthFinder(KNOWN_DISTANCE, CHAIR_WIDTH, chair_width_in_rf);
        focal_table = focalLengthFinder(KNOWN_DISTANCE, TABLE_WIDTH, table_width_in_rf);

        print(focal_chair);
        print(focal_table);

        setState(() {
          isLoaded = true;
          isDetecting = false;
          yoloResults = [];
        });
      });
    });
 
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
  final result = await vision.yoloOnFrame(
      bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      iouThreshold: 0.4,
      confThreshold: 0.4,
      classThreshold: 0.5);
  if (result.isNotEmpty) {
    setState(() {
      yoloResults = result;
    });
    

    for (var object in yoloResults) {

      // Wait for the previous text-to-speech to finish
      while (isSpeaking) {
        await Future.delayed(Duration(milliseconds: 100));
      }

      if (object["tag"]== 'chair'){
        
        distance = distanceFinder(focal_chair, CHAIR_WIDTH, (object["box"][2] - object["box"][0]));
        distance_text='there is Chair withing ${distance.toStringAsFixed(0)}  inches';
        var result1 = await ftts.speak(distance_text);
        if (result1 == 1) {
          // Speaking
          setState(() {
            isSpeaking = true;
          });
        } else {
          // Not speaking
        }
      }
        else if(object["tag"]== 'Sofa'){
        
        distance = distanceFinder(focal_chair, CHAIR_WIDTH, (object["box"][2] - object["box"][0]));
        distance_text='there is Sofa withing ${distance.toStringAsFixed(0)}  inches';
        var result1 = await ftts.speak(distance_text);
        if (result1 == 1) {
          // Speaking
          setState(() {
            isSpeaking = true;
          });
        } else {
          // Not speaking
        }
      }
      else{
        distance = distanceFinder(focal_table, TABLE_WIDTH,(object["box"][2] - object["box"][0]));
        distance_text='there is Table withing ${distance.toStringAsFixed(0)}  inches';
        var result1 = await ftts.speak(distance_text);
        if (result1 == 1) {
            setState(() {
              isSpeaking = true;
            });
          // Speaking
        } else {
          // Not speaking
        }
      }
    }
   
    print(result);
  }
}

Future<void> startDetection() async {
setState(() {
  isDetecting = true;
});
if (controller.value.isStreamingImages) {
  return;
}
await controller.startImageStream((image) async {
  if (isDetecting) {
    cameraImage = image;
    yoloOnFrame(image);
  }
});
}

Future<void> stopDetection() async {
  setState(() {
    isDetecting = false;
    yoloResults.clear();
  });
}

    List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    // [{box: [102.73690795898438, 3.2826080322265625, 153.16390991210938, 58.30506896972656, 0.9976664781570435], tag: cat}]

    return yoloResults.map((result) {
      if (result["tag"]== 'chair'){
        
        distance = distanceFinder(focal_chair, CHAIR_WIDTH, (result["box"][2] - result["box"][0]));
      }
      else if (result["tag"]== 'Sofa') {
        // code to execute if condition2 is true
        distance = distanceFinder(focal_chair, CHAIR_WIDTH, (result["box"][2] - result["box"][0]));
        
      }
      else{

        distance = distanceFinder(focal_table, TABLE_WIDTH,(result["box"][2] - result["box"][0]));

      }
      print('distance is $distance inches');

      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}% ${distance.toStringAsFixed(0)} inches",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }

    @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(
              controller,
            ),
          ),
          ...displayBoxesAroundRecognizedObjects(size),
          Positioned(
            bottom: 75,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 5, color: Colors.white, style: BorderStyle.solid),
              ),
              child: isDetecting
                  ? IconButton(
                      onPressed: () async {
                        stopDetection();
                      },
                      icon: const Icon(
                        Icons.stop,
                        color: Colors.red,
                      ),
                      iconSize: 50,
                    )
                  : IconButton(
                      onPressed: () async {
                        await startDetection();
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                      iconSize: 50,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() async{
    super.dispose();
    controller.dispose();
    await vision.closeYoloModel();
  }
}
