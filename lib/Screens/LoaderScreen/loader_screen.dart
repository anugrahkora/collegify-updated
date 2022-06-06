import '../../shared/components/constants.dart';
import '../../shared/components/loadingWidget.dart';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class LoaderScreen extends StatefulWidget {
  @override
  _LoaderScreenState createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Loader(
        color: Theme.of(context).primaryColor,
        size: 30.0,
        spinnerColor: Theme.of(context).primaryTextTheme.bodyText1.color,
      ),
    );
  }
}
