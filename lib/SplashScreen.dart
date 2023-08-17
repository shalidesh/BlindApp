import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:bindappp/home.dart';

import 'home2.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Lottie.asset('assets/loading-circles.json'),

        // Column(
        //   children: [
               ///TODO Add your image under assets folder
        //     Image.asset('assets/logo_icon.png'),
        //     const Text('Blind app', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),)
        //   ],
        // ),
        backgroundColor: Colors.red,
        nextScreen:  SpeechScreen(),
      splashIconSize: 250,
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(seconds: 1),
    );
  }
}