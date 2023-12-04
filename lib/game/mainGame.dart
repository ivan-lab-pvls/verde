// ignore_for_file: file_names, unnecessary_import, library_private_types_in_public_api, deprecated_member_use

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verdeForest/game/expedition/ExpeditionScreen.dart';
import 'package:verdeForest/game/expedition/ReceiptScreen.dart';
import 'package:verdeForest/verde/game1/game1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MainGamePage extends StatefulWidget {
  const MainGamePage({super.key});

  @override
  _MainGamePageState createState() => _MainGamePageState();
}

class _MainGamePageState extends State<MainGamePage> {
  SharedPreferences? prefs;

  late Timer timer;
  int balance = 0;
  @override
  void initState() {
    super.initState();
    _initializePrefs().then((SharedPreferences preferences) {
      setState(() {
        prefs = preferences;
        balance = prefs?.getInt('balance') ?? 500;
      });
    });
    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      loadMusic();
    });
  }

  Future<SharedPreferences> _initializePrefs() async {
    return await SharedPreferences.getInstance();
  }

  StreamController<int> healthStreamController =
      StreamController<int>.broadcast();

  StreamController<int> energyStreamController =
      StreamController<int>.broadcast();
  privAndTerms(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Error for launch Privacy Policy';
    }
  }

  Future<void> loadMusic() async {
    // prefs = await SharedPreferences.getInstance();
    // bool soundValue = prefs.getBool('music') ?? false;
    // if (soundValue == true) {
    //   audio.playAudio();
    // } else {
    //   audio.stopAudio();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Stack(
            children: [
              Image.asset(
                'assets/verde/back_onb.png',
                key: UniqueKey(),
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .33,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      height: 130,
                      width: 130,
                      child: Image.asset(
                        'assets/verde/owl.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * .4,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/verde/balance.png"),
                              fit: BoxFit.contain,
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                balance.toString(),
                                style: GoogleFonts.seymourOne(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Receipt(),
                              ),
                            );
                          },
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width * .4,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/verde/recipes.png"),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Container(
                        //   height: 40,
                        //   width: 40,
                        //   decoration: const BoxDecoration(
                        //     image: DecorationImage(
                        //       image: AssetImage("assets/verde/sound.png"),
                        //       fit: BoxFit.contain,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * .35,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .23,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Game1(),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * .45,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/verde/game1.png"),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Game2(),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * .45,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/verde/game2.png"),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * .7,
                child: Container(
                  height: MediaQuery.of(context).size.height * .3,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/verde/girlb.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
