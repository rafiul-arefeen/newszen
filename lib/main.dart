import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import the package
import 'package:news_zen/features/splash/splash_wrapper.dart';
import 'package:news_zen/newszen.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashWrapper(),
  ));
}
