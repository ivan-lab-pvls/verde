// ignore_for_file: file_names, unnecessary_import, library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Game2 extends StatefulWidget {
  const Game2({super.key});

  @override
  _Game1State createState() => _Game1State();
}

class _Game1State extends State<Game2> {
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
      body: Stack(
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
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: Image.asset('assets/verde/btn_back.png'),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .4,
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
                          color: const Color.fromARGB(255, 255, 255, 255),
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Ошибка: ${snapshot.error}'));
                  }

                  Map<String, int> imageNumberMap = snapshot.data ?? {};

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                            image: AssetImage('assets/verde/oval.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: SizedBox(
                            height: 60,
                            width: 60,
                            child: Image.asset(imagePath, fit: BoxFit.contain),
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
    );
  }
}
