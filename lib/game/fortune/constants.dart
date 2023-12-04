
import 'package:shared_preferences/shared_preferences.dart';

String bonuses = 'typeHaventBonuses';
bool isBonuses = false;
late SharedPreferences prefers;


Future<void> init() async {
  prefers = await SharedPreferences.getInstance();
}

