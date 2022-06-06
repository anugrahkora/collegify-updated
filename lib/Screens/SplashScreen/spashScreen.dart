import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class SpashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: HexColor(appPrimaryColour),
      body: Center(
        child: Container(
          height: 120.0,
          width: size.width * 0.8,
          decoration: new BoxDecoration(
            image: DecorationImage(
              image: new AssetImage('assets/images/collegify_cropped.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
