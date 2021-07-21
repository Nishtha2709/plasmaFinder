import 'dart:async';
import 'package:flutter/material.dart';
import 'screens/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: "STIX Two Math"
      ),
      home: AnimatedSplashScreen(
        splash:Image.asset('assets/icon/plasma-logo.png'),
        nextScreen: MyHomePage(),
        splashTransition: SplashTransition.slideTransition,
        splashIconSize: 500,
      ),
    );
  }
}

