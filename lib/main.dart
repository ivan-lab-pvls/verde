import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game/data/config.dart';
import 'game/data/notifx.dart';
import 'game/data/roll.dart';
import 'game/fortune/constants.dart';
import 'game/mainGame.dart';
import 'game/onBoarding/onBoarding_screen.dart';
import 'game/onBoarding/user_widget.dart';

late SharedPreferences prefs;
final remoteConfig = FirebaseRemoteConfig.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 1),
    minimumFetchInterval: const Duration(seconds: 1),
  ));
  await NotificationServiceFb().activate();
  final bool shouldShowRedContainer = await checkUserCoinsForGame();
  await isRateCalled();
  prefs = await SharedPreferences.getInstance();
  runApp(MyApp(shouldShowRedContainer));
}

class MyApp extends StatelessWidget {
  final bool getUserDailyBonus;

  const MyApp(this.getUserDailyBonus, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(getUserDailyBonus),
    );
  }
}

class MainScreen extends StatefulWidget {
  final bool shouldShowRedContainer;

  const MainScreen(this.shouldShowRedContainer, {super.key});

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
      duration: const Duration(seconds: 3),
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
    if (showBons != null) {
      return ShowRewardBonusesMan(
        bonusesAmount: showBons!,
      );
    } else {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 60, 154, 231),
        body: FutureBuilder<bool>(
          future: getBoolFromPrefs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LinearPercentIndicator(
                  barRadius: const Radius.circular(25),
                  width: MediaQuery.of(context).size.width,
                  lineHeight: 14.0,
                  percent: index,
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  progressColor: const Color.fromARGB(255, 116, 186, 243),
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
        ),
      );
    }
  }

  Future<bool> getBoolFromPrefs() async {
    final bool value = prefs.getBool('start') ?? false;

    await Future.delayed(const Duration(seconds: 2));

    return value;
  }
}
