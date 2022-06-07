import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../controllers/app_controller.dart';

Widget darkModeSwitch(BuildContext context) {
  return ValueListenableBuilder(
      valueListenable: Hive.box('darkMode').listenable(),
      builder: (context, box, widget) {
        // settingsController.settings.value.isDarkMode
        final darkMode = box.get('darkMode', defaultValue: true);
        return Container(
          width: 30.0,
          // child: IconButton(
          //     onPressed: () {
          //       HiveController.saveTheme(darkMode ? false : true);
          //     },
          //     icon: Icon(Icons.brightness_medium))

          child: SwitchListTile(
              activeColor: Theme.of(context).colorScheme.secondary,
              activeTrackColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.4),
              // tileColor: Colors.amber,

              value: darkMode,
              onChanged: (val) {
                HiveController.saveTheme(val);
              }),
        );
      });
}
