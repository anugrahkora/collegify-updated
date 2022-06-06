import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/models/user_model.dart';
import 'package:collegify/shared/components/loadingWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../database/databaseService.dart';
import '../../shared/components/constants.dart';

class AdminVerifyTeacherScreen extends StatefulWidget {
  final AdminModel adminModel;

  const AdminVerifyTeacherScreen({Key key, @required this.adminModel})
      : super(key: key);
  @override
  _AdminVerifyTeacherScreenState createState() =>
      _AdminVerifyTeacherScreenState();
}

class _AdminVerifyTeacherScreenState extends State<AdminVerifyTeacherScreen> {
  DatabaseService _databaseService = new DatabaseService();
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: HexColor(appPrimaryColour),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black54, //change your color here
        ),
        backgroundColor: Theme.of(context).primaryColorLight,
        title: HeadingText(
          alignment: Alignment.centerLeft,
          text: 'Verify teacher',
          size: 17.0,
          color:Theme.of(context).primaryTextTheme.bodyText1.color,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
           
            .where('Role', isEqualTo: 'notVerified')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Loader(
                color: Theme.of(context).primaryColor,
                size: 30.0,
                spinnerColor: Colors.black54);
          if (snapshot.hasError) {
            return HeadingText(
              text: 'Unknown error occured',
              size: 17.0,
              color:Theme.of(context).primaryTextTheme.bodyText1.color,
            );
          } else if (snapshot.data.docs.length == 0) {
            return HeadingText(
              text: 'No teachers to verify',
              size: 17.0,
              color:Theme.of(context).primaryTextTheme.bodyText1.color,
            );
          }
          List<DecoratedContainer> decoratedContainer = [];
          for (int i = 0; i < snapshot.data.docs.length; ++i) {
            DocumentSnapshot documentSnapshot = snapshot.data.docs[i];
            decoratedContainer.add(
              DecoratedContainer(
                child: SwitchListTile(
                  activeColor: Colors.greenAccent,
                  activeTrackColor: Colors.green,
                  inactiveThumbColor: Colors.redAccent,
                  inactiveTrackColor: Colors.red,
                  title: HeadingText(
                    alignment: Alignment.centerLeft,
                    color:Theme.of(context).primaryTextTheme.bodyText1.color,
                    text: documentSnapshot.data()['Name'],
                    size: 15.0,
                  ),
                  subtitle: HeadingText(
                    alignment: Alignment.centerLeft,
                    color:Theme.of(context).primaryTextTheme.bodyText1.color,
                    text: documentSnapshot.data()['Email'] ?? '---',
                    size: 13.0,
                  ),
                  value: _value,
                  onChanged: (val) async {
                    if (!_value) {
                      dynamic result = await _databaseService
                          .verifyTeachers(documentSnapshot.id);
                      if (result != null) {
                        Fluttertoast.showToast(msg: result);
                      } else
                        Fluttertoast.showToast(msg: 'Verified');
                      setState(() {
                        _value = !_value;
                      });
                      // Fluttertoast.showToast(msg: 'On');
                    } else if (_value) {
                      Fluttertoast.showToast(msg: 'Failed');
                      // setState(() {
                      //   _value = !_value;
                      // });
                    }
                  },
                ),
              ),
            );
          }
          return Container(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: decoratedContainer,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ListViewListTile extends StatefulWidget {
  final String teacherName;
  final DocumentSnapshot documentSnapshot;

  const ListViewListTile({Key key, this.teacherName, this.documentSnapshot})
      : super(key: key);
  @override
  _ListViewListTileState createState() => _ListViewListTileState();
}

class _ListViewListTileState extends State<ListViewListTile> {
  String _teacherUid;
  Future _getUid(String name) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      return await firebaseFirestore
          .collection('users')
          .where('University',
              isEqualTo: widget.documentSnapshot.data()['University'])
          .where('College',
              isEqualTo: widget.documentSnapshot.data()['College'])
          .where('Role', isEqualTo: 'notVerified')
          .where('Name', isEqualTo: name)
          .get()
          .then((query) {
        query.docs.forEach((element) {
          if (element.exists) {
            setState(() {
              _teacherUid = element.id;
            });
          }
        });
      });
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  DatabaseService _databaseService = new DatabaseService();
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.topCenter,
      // margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(6, 2),
              blurRadius: 6.0,
              spreadRadius: 0.0),
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(-6, -2),
              blurRadius: 6.0,
              spreadRadius: 0.0),
        ],
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SwitchListTile(
        activeColor: Colors.greenAccent,
        activeTrackColor: Colors.green,
        inactiveThumbColor: Colors.redAccent,
        inactiveTrackColor: Colors.red,
        title: HeadingText(
          alignment: Alignment.centerLeft,
          color: Colors.black54,
          text: widget.teacherName,
          size: 20,
        ),
        value: _value,
        onChanged: (val) async {
          await _getUid(widget.teacherName);
          if (!_value) {
            dynamic result = await _databaseService.verifyTeachers(_teacherUid);
            if (result != null) {
              Fluttertoast.showToast(msg: result);
            } else
              Fluttertoast.showToast(msg: 'Verified');
            setState(() {
              _value = !_value;
            });
            Fluttertoast.showToast(msg: 'On');
          } else if (_value) {
            Fluttertoast.showToast(msg: 'Off');
            // setState(() {
            //   _value = !_value;
            // });
          }
        },
      ),
    );
  }
}
