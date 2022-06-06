import 'package:collegify/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart'; 
import 'Screens/welcome_screen/get_doc.dart';
import 'authentication/auth_service.dart';
import 'models/user_model.dart';
import 'shared/components/constants.dart';

void main() async {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarIconBrightness: Brightness.dark,
  //   //systemNavigationBarColor: Colors.blue, // navigation bar color
  //   statusBarColor: HexColor(appPrimaryColour), // status bar color
  // ));

  WidgetsFlutterBinding.ensureInitialized();

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
      child: GetMaterialApp(
         theme: lightTheme(context),
        darkTheme: darkTheme(context),
        // color: HexColor(appPrimaryColour),
        debugShowCheckedModeBanner: false,
        home: GetUserDocument(),
      ),
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
