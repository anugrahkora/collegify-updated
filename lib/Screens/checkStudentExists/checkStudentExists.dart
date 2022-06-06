import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/authentication/auth_service.dart';
import 'package:collegify/database/databaseService.dart';
import 'package:collegify/models/user_model.dart';
import 'package:collegify/shared/components/constants.dart';
import 'package:collegify/shared/components/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

class CheckStudentExists extends StatefulWidget {
  final ParentModel parentModel;
  final String uid;

  const CheckStudentExists({Key key, @required this.parentModel,@required this.uid})
      : super(key: key);
  @override
  _CheckStudentExistsState createState() => _CheckStudentExistsState();
}

class _CheckStudentExistsState extends State<CheckStudentExists> {
  DatabaseService databaseService = new DatabaseService();
  final AuthService _authService = new AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: HexColor(appPrimaryColour),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: HeadingText(
          text: 'Check Student',
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
          size: 17.0,
          alignment: Alignment.centerLeft,
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.black54,
              ),
              onPressed: () async {
                await _authService.signOut();
              })
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('Registration_Number',
                isEqualTo: widget.parentModel.regNumber)
            .where('Role', isEqualTo: 'student')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Loader(
              size: 20.0,
              color: Theme.of(context).primaryColor,
            );
          if (snapshot.data.docs.length == 0)
            return DecoratedCard(
              onTap: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ImageIcon(
                    AssetImage('assets/icons/iconStudentLarge.png'),
                    color: Colors.black54,
                    size: 50,
                  ),
                  HeadingText(
                    alignment: Alignment.centerLeft,
                    text: widget.parentModel.regNumber,
                    size: 15.0,
                    color: Theme.of(context).primaryTextTheme.bodyText1.color,
                  ),
                  HeadingText(
                    alignment: Alignment.centerLeft,
                    text:
                        'Oops, Such a student with the Registration Number doesnt exists in our database ',
                    size: 15.0,
                    color: Colors.red,
                  ),
                  HeadingText(
                    alignment: Alignment.centerLeft,
                    text: "You can Sign-Out and check again",
                    size: 15.0,
                    color: Colors.amber,
                  ),
                ],
              ),
            );
          try {
            databaseService.verifyParent(widget.uid);
            Fluttertoast.showToast(msg: 'Verified');
          } on FirebaseException catch (e) {
            Fluttertoast.showToast(msg: e.message);
          }
          return SafeArea(
            child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, index) {
                return DecoratedCard(
                  onTap: () {},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ImageIcon(
                        AssetImage('assets/icons/iconStudentLarge.png'),
                        color: Colors.black54,
                        size: 50,
                      ),
                      HeadingText(
                        alignment: Alignment.centerLeft,
                        text: widget.parentModel.regNumber,
                        size: 15.0,
                        color: Theme.of(context).primaryTextTheme.bodyText1.color,
                      ),
                      HeadingText(
                        alignment: Alignment.centerLeft,
                        text:
                            'You have been Verified, to go to the home page, please restart the application! ',
                        size: 15.0,
                        color: Colors.green,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
