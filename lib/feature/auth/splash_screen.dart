import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:paywize_task/feature/dashboard/presentation/pages/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 5), () {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade300,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Gap(10),
            Image.network(
              height: 50,
              width: 40,
              "https://media.licdn.com/dms/image/v2/D560BAQEZ4qxJYu49pA/company-logo_200_200/B56ZdWKiH5H8AU-/0/1749497291936/paywizetechnologies_logo?e=2147483647&v=beta&t=tlbB3ImiIZ2lRd4OZem00ecSd_vJkJOJBMtJ-_nm5uk",
            ),
            Gap(10),
            Text(
              "Welcome To Paywize\nYour Trading Companion !",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
