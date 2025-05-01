import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/newszen.dart'; // Import Newszen

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Newszen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: main_background_colour,
      body: Center(
        child: OverflowBox(
          minHeight: screenWidth,
          maxHeight: screenHeight,
          child: Lottie.asset(
            'assets/animations/splash_animation.json',
            fit: BoxFit.cover,
            repeat: false, // Disable looping
            onLoaded: (composition) {
              // Set the AnimationController duration to match the Lottie animation duration
              _controller.duration = composition.duration;
              _controller.forward(
                  from: 0.0); // Start the animation from the beginning
            },
            controller:
                _controller, // Link the controller to the Lottie animation
          ),
        ),
      ),
    );
  }
}
