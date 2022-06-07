import 'package:collegify/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'Screens/welcome_screen/get_doc.dart';
import 'authentication/auth_service.dart';
import 'models/user_model.dart';
import 'shared/components/constants.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('darkMode');
  dynamic result = await Firebase.initializeApp();

  result != null
      ? runApp(InitializeMyapp())
      : runApp(ErrorInitializingBackend());
}

class InitializeMyapp extends StatelessWidget {
  // final Connectivity _connectivity = Connectivity();
  // StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
      value: AuthService().user,
      child: ValueListenableBuilder(
          valueListenable: Hive.box('darkMode').listenable(),
          builder: (context, box, widget) {
            final darkMode = box.get('darkMode', defaultValue: true);
            return GetMaterialApp(
              theme: lightTheme(context),
              darkTheme: darkTheme(context),
              themeMode: darkMode == true ? ThemeMode.dark : ThemeMode.light,
              // color: HexColor(appPrimaryColour),
              debugShowCheckedModeBanner: false,
              home: GetUserDocument(),
            );
          }),
    );
  }
}

class ErrorInitializingBackend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
            child: Center(
          child: HeadingText(
            text: 'Error Initializing app',
            size: 20,
            color: Theme.of(context).primaryTextTheme.bodyText1.color,
          ),
        )),
      ),
    );
  }
}
