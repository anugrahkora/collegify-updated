import 'package:collegify/authentication/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../shared/components/constants.dart';
import '../../shared/components/loadingWidget.dart';

class NotVerifiedScreen extends StatefulWidget {
  @override
  _NotVerifiedScreenState createState() => _NotVerifiedScreenState();
}

class _NotVerifiedScreenState extends State<NotVerifiedScreen> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black54, //change your color here
          ),
          backgroundColor: Theme.of(context).primaryColorLight,
          title: HeadingText(
            alignment: Alignment.centerLeft,
            text: 'Not Verified',
            size: 17.0,
            color: Theme.of(context).primaryTextTheme.bodyText1.color,
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await _authService.signOut();
                })
          ],
        ),
        // backgroundColor: HexColor(appPrimaryColour),
        body: Center(
          child: SafeArea(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: size.height * 0.4),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: HeadingText(
                      text:
                          "Please wait until you are authorized. Please contact your admin in charge for verification if the process take long, if done, please restart the app.",
                      size: 17.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Loader(
                  size: 30.0,
                  color: Theme.of(context).primaryColor,
                  spinnerColor: Colors.black87,
                )
              ],
            ),
          ),
        ));
  }
}
