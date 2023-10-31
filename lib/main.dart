import 'package:flutter/material.dart';
import 'package:flutter/animation.dart'; // Импортируйте необходимую библиотеку
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'game/mainGame.dart';
import 'game/onBoarding/onBoarding_screen.dart';

late SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  double index = 0.0;

  @override
  void initState() {
    super.initState();
    animateProgress();
  }

  void animateProgress() async {
    final animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    final animation =
        Tween<double>(begin: 0, end: 1).animate(animationController);

    animation.addListener(() {
      setState(() {
        index = animation.value;
      });
    });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getBoolFromPrefs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.blueAccent,
            body: Center(
              child: LinearPercentIndicator(
                barRadius: const Radius.circular(25),
                width: MediaQuery.of(context).size.width,
                lineHeight: 14.0,
                percent: index,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                progressColor: const Color.fromARGB(255, 116, 186, 243),
              ),
            ),
          );
        } else {
          final bool boolValue = snapshot.data ?? false;
          if (boolValue) {
            return const MainGamePage();
          } else {
            return OnBoardingScreen();
          }
        }
      },
    );
  }

  Future<bool> getBoolFromPrefs() async {
    final bool value = prefs.getBool('start') ?? false;
    await Future.delayed(const Duration(seconds: 2));
    return value;
  }
}
