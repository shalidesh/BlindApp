import 'package:bindappp/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class CameraScreenTest extends StatefulWidget {
  const CameraScreenTest({super.key});

  @override
  State<CameraScreenTest> createState() => _CameraScreenTestState();
}

class _CameraScreenTestState extends State<CameraScreenTest> {
  bool isWorking = false;
  String result = "";
  late CameraController cameraController;
  // late CameraController cameraController;
  CameraImage? imgCamera;

  lodaModel() async {
    await Tflite.loadModel(
      model: "assets/mobilenet_v1_1.0_224.tflite",
      labels: "assets/mobilenet_v1_1.0_224.txt",
    );
  }

  @override
  void dispose() async {
    await Tflite.close();
    cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    lodaModel();
  }

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) => {
              if (!isWorking)
                {
                  isWorking = true,
                  imgCamera = imageFromStream,
                  runModelOnStramFrames(),
                }
            });
      });
    });
  }

  runModelOnStramFrames() async {
    if (imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: imgCamera!.height,
        imageWidth: imgCamera!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );

      result = "";

      recognitions!.forEach((response) {
        result += response["label"] +
            " " +
            (response["confidence"] as double).toStringAsFixed(2) +
            "\n\n";
      });

      setState(() {
        result;
      });
      isWorking = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              GestureDetector(
                onTap: () {
                  initCamera();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 35),
                  height: 500,
                  width: 350,
                  child: imgCamera == null
                      ? Container(
                          height: 500,
                          width: 350,
                          color: Colors.green,
                          child: const Icon(
                            Icons.photo_camera_front,
                            color: Colors.blueAccent,
                            size: 40,
                          ),
                        )
                      : AspectRatio(
                          aspectRatio: cameraController.value.aspectRatio,
                          child: CameraPreview(cameraController),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 100.0,
                  color: Colors.green,
                  child: Text(
                    result,
                    style: TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
