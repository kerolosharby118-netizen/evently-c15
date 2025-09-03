import 'package:evently_c15/ui/utils/app_assets.dart';
import 'package:evently_c15/ui/utils/app_routes.dart';
import 'package:flutter/material.dart';

import '../onboarding_screen/onboarding_screen.dart';

class Splash extends StatefulWidget {
  static const routeName = "Splash" ;

  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        AppAssets.splash,
        fit: BoxFit.fill,
      ),
    );
  }
}
