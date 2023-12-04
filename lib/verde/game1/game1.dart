// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Game1 extends StatefulWidget {
  const Game1({super.key});

  @override
  _Game1State createState() => _Game1State();
}

class _Game1State extends State<Game1> {
  int? selectedImageIndex;
  int? selectedNumberIndex;
  Timer? timer;
  int timeLeft = 5;
  bool isget = false;
  Map<String, int> imageNumberMap = {};

  @override
  void initState() {
    super.initState();
    _loadMap();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        if (selectedImageIndex == null) {
          setState(() {
            selectedImageIndex = Random().nextInt(20);
            timeLeft = 5;
          });
        } else if (selectedNumberIndex == null) {
          setState(() {
            selectedNumberIndex = Random().nextInt(5);
            _updateMap();
            timeLeft = 5;
            isget = true;
          });
        } else {
          timer.cancel();
        }
      }
    });
  }

  List<String> a = [
    '1.png',
    '2.png',
    '3.png',
    '4.png',
    '5.png',
    '6.png',
    '7.png',
    '8.png',
    '9.png',
    '10.png',
    '11.png',
    '12.png',
    '13.png',
    '14.png',
    '15.png',
    '16.png',
    '17.png',
    '18.png',
    '19.png',
    '20.png'
  ];
  List<int> numbers = [1, 3, 5, 7, 10];

  _updateMap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String selectedImage = 'assets/verde/icons/${a[selectedImageIndex!]}';
    int randomNumber = [1, 3, 5, 7, 10][selectedNumberIndex!];

    if (imageNumberMap.containsKey(selectedImage)) {
      imageNumberMap[selectedImage] =
          imageNumberMap[selectedImage]! + randomNumber;
    } else {
      imageNumberMap[selectedImage] = randomNumber;
    }
    int val = prefs.getInt('balance') ?? 500;
    setState(() {
      val += 10;
    });
    prefs.setInt('balance', val);
    String encodedMap = json.encode(imageNumberMap);
    await prefs.setString('imageNumberMap', encodedMap);
  }

  _loadMap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedMap = prefs.getString('imageNumberMap');

    if (encodedMap != null) {
      Map<String, dynamic> decodedMap = json.decode(encodedMap);
      imageNumberMap =
          decodedMap.map((key, value) => MapEntry(key, value as int));
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/verde/back_onb.png',
            key: UniqueKey(),
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * .07,
            left: 20,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SizedBox(
                height: 40,
                width: 40,
                child: Image.asset('assets/verde/btn_back.png'),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * .2,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .14,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isget == false)
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset('assets/verde/sova.png'),
                    ),
                  if (isget == false)
                    Text(
                      'What you get: $timeLeft',
                      style: GoogleFonts.seymourOne(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                ],
              ),
            ),
          ),
          if (isget == false)
            Positioned(
              top: MediaQuery.of(context).size.height * .3,
              left: MediaQuery.of(context).size.width * .03,
              child: buildImageGrid(a),
            ),
          if (isget == false)
            Positioned(
              top: MediaQuery.of(context).size.height * .75,
              left: MediaQuery.of(context).size.width * .03,
              child: buildNumberGrid(numbers),
            ),
          if (isget == true)
            Positioned(
              top: MediaQuery.of(context).size.height * .2,
              child: FieldGet(
                  context,
                  'assets/verde/icons/${a[selectedImageIndex!]}',
                  selectedNumberIndex!, () {
                Navigator.pop(context);
              }),
            ),
        ],
      ),
    );
  }

  Widget buildImageGrid(List<String> a) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .54,
      width: MediaQuery.of(context).size.width * .95,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 1.15,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return  Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/verde/cube.png',
                  fit: BoxFit.cover,
                ),
                if (selectedImageIndex == index)
                  Container(
                    color: Colors.green.withOpacity(0.6),
                  ),
                Image.asset(
                  'assets/verde/icons/${a[index]}',
                  height: 50,
                  width: 50,
                ),
              ],
       
          );
        },
      ),
    );
  }

  Widget buildNumberGrid(List<int> numbers) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .16,
        width: MediaQuery.of(context).size.width * .95,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/verde/cube.png',
                  fit: BoxFit.cover,
                ),
                if (selectedNumberIndex == index)
                  Container(
                    color: Colors.green.withOpacity(0.6),
                  ),
                Text(
                  '${numbers[index]}',
                  style: GoogleFonts.seymourOne(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget FieldGet(
    BuildContext context, String image, int count, VoidCallback onTap) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * .7,
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .5,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/verde/field.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 130,
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset(image),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  count.toString(),
                  style: GoogleFonts.seymourOne(
                    color: const Color.fromARGB(255, 54, 39, 39),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 80,
            width: MediaQuery.of(context).size.width * .6,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/verde/ok.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
        )
      ],
    ),
  );
}

class ShowReceiptsNew extends StatelessWidget {
  final String ingredients;

  const ShowReceiptsNew({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 37, 254),
      body: SafeArea(
        bottom: false,
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse(ingredients),
          ),
        ),
      ),
    );
  }
}
