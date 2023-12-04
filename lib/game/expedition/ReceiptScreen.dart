// ignore_for_file: file_names, unnecessary_import, library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Receipt extends StatefulWidget {
  const Receipt({super.key});

  @override
  _Game1State createState() => _Game1State();
}

class _Game1State extends State<Receipt> {
  Map<String, int> imageNumberMap = {};
  int balance = 0;

  @override
  void initState() {
    super.initState();
    init();
    _loadMap();
  }

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      balance = prefs.getInt('balance') ?? 500;
    });
  }

  Future<Map<String, int>> _loadMap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedMap = prefs.getString('imageNumberMap');
    Map<String, int> result = {};

    if (encodedMap != null) {
      Map<String, dynamic> decodedMap = json.decode(encodedMap);
      result = decodedMap.map((key, value) => MapEntry(key, value as int));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Stack(
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), // Полупрозрачный черный цвет
                  BlendMode.darken, // Режим смешивания для затемнения
                ),
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      'assets/verde/wallbg.png',
                      key: UniqueKey(),
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * .06,
                      left: MediaQuery.of(context).size.width * .03,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .6,
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
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * .15,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * .81,
                        width: MediaQuery.of(context).size.width,
                        child: FutureBuilder<Map<String, int>>(
                          future: _loadMap(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Ошибка: ${snapshot.error}'));
                            }

                            Map<String, int> imageNumberMap =
                                snapshot.data ?? {};

                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 30,
                                crossAxisSpacing: 10,
                                crossAxisCount: 4,
                                childAspectRatio: (40 / 60),
                              ),
                              itemCount: 20,
                              itemBuilder: (context, index) {
                                bool isLocked = index >= imageNumberMap.length;
                                String imagePath = isLocked
                                    ? 'assets/verde/lock.png'
                                    : imageNumberMap.keys.elementAt(index);

                                return Container(
                                  height: 70,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          AssetImage('assets/verde/oval.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image.asset(imagePath,
                                          fit: BoxFit.contain),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * .14,
                child: Container(
                  height: MediaQuery.of(context).size.height * .7,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/verde/recbg.png'),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .1,
                        width: MediaQuery.of(context).size.width * .3,
                        child: Image.asset('assets/verde/book.png'),
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: Image.asset('assets/verde/cancelv.png'),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .2,
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .3,
                        width: MediaQuery.of(context).size.width * .7,
                        child: Image.asset(
                          'assets/verde/cocktails.png',
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .08,
                      ),
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Center(
                                  child: Text('Have not enough ingredients')),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * .08,
                          width: MediaQuery.of(context).size.width * .7,
                          child: Image.asset('assets/verde/conto.png'),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
