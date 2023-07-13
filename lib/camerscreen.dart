import 'package:bindappp/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool isWorking = false;
  String result = "";
  late CameraController cameraController;
  // late CameraController cameraController;
  CameraImage? imgCamera;

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
                }
            });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/user.jpg")),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: 320,
                    width: 330,
                    child: Image.asset("assets/user.jpg"),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      initCamera();
                      print('logged');
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 35),
                      height: 270,
                      width: 360,
                      child: imgCamera == null
                          ? Container(
                              height: 270,
                              width: 360,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
