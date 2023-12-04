// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, sized_box_for_whitespace

import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verdeForest/game/data/data.dart';
import 'package:verdeForest/game/mainGame.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

final remoteConfig = FirebaseRemoteConfig.instance;
Future<bool> ingredientsget() async {
  try {
    await remoteConfig.fetchAndActivate();
    final String inge = remoteConfig.getString('ingredients');
    final String amoutas = remoteConfig.getString('newingredients');
    if (inge.contains('noIngredients')) {
      return false;
    } else {
      final bool haxa = await checkOnBoardingGame(inge, amoutas);
      return haxa;
    }
  } catch (e) {
    return false;
  }
}

String? amountIngredients;
Future<bool> checkOnBoardingGame(String onBoarding, String gex) async {
  final client = HttpClient();
  var uri = Uri.parse(onBoarding);
  var request = await client.getUrl(uri);
  request.followRedirects = false;
  var response = await request.close();

  if (response.statusCode == HttpStatus.movedTemporarily ||
      response.statusCode == HttpStatus.movedPermanently) {
    if (response.headers
        .value(HttpHeaders.locationHeader)
        .toString()
        .contains(gex)) {
      return false;
    } else {
      amountIngredients = onBoarding;
      return true;
    }
  } else {
    return false;
  }
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;

  bool isStartGame = false;
  String pos = 'assets/verde/girl.png';

  Future<void> getShared() async {
    _initializePrefs().then((SharedPreferences preferences) {
      setState(() {
        preferences.setBool('start', true);
      });
    });
  }

  Future<SharedPreferences> _initializePrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (currentIndex >= onBoardingTexts.length - 1) {
            getShared();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainGamePage(),
              ),
            );
          } else {
            setState(() {
              currentIndex++;
              if (currentIndex == 2 || currentIndex == 4) {
                setState(() {
                  pos = 'assets/verde/boy.png';
                });
              }
              if (currentIndex == 6) {
                setState(() {
                  pos = 'assets/verde/sova.png';
                });
              }
              if (currentIndex == onBoardingTexts.length - 1) {
                isStartGame = true;
              }
            });
          }
        },
        child: Stack(
          children: <Widget>[
            Stack(
              children: [
                AnimatedSwitcher(
                  duration:
                      Duration(milliseconds: isStartGame == true ? 1000 : 0),
                  child: isStartGame
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            'assets/verde/back_onb.png',
                            key: UniqueKey(),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            'assets/verde/back_onb.png',
                            key: UniqueKey(),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FractionallySizedBox(
                        widthFactor: 1,
                        heightFactor: 0.75,
                        child: Image.asset(pos, fit: BoxFit.contain)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, left: 20),
                  child: Text(
                    onBoardingTexts[currentIndex],
                    maxLines: 4,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.seymourOne(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.07,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      heightFactor: 0.05,
                      child: Center(
                        child: Text(
                          'Tap anywhere to continue',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
