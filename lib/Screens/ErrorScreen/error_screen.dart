import '../../shared/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ErrorScreen extends StatefulWidget {
  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: HexColor(appPrimaryColour),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 120.0,
              width: size.width * 0.8,
              decoration: new BoxDecoration(
                image: DecorationImage(
                  image: new AssetImage('assets/images/collegify_cropped.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: HeadingText(
                text: 'Error Initializing,Please Check your network connection',
                textAlign: TextAlign.center,
                size: 18,
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
