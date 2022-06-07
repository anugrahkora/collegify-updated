

import 'package:fluttertoast/fluttertoast.dart';

import 'package:hive/hive.dart';

class HiveController {
  
  

  static Future saveTheme(bool value) async {
    try {
      final settingsBox = Hive.box('darkMode');
      await settingsBox.put('darkMode', value);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Unknown Error Occured');
    }
  }

  
}
