import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/database/databaseService.dart';
import 'package:collegify/models/user_model.dart';
import 'package:collegify/shared/components/constants.dart';
import 'package:collegify/shared/components/dropDownList.dart';
import 'package:collegify/shared/components/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

class OpenOptionPopUp extends StatefulWidget {
  final TeacherModel teacherModel;
  final String courseName;
  final String registrationNumber;
  final String studentUID;

  const OpenOptionPopUp(
      {Key key,
      @required this.teacherModel,
      @required this.registrationNumber,
      @required this.courseName,
      @required this.studentUID})
      : super(key: key);

  @override
  _OpenOptionPopUpState createState() => _OpenOptionPopUpState();
}

class _OpenOptionPopUpState extends State<OpenOptionPopUp> {
  String _newSemester;
  bool _loading = false;
  final _formkey = GlobalKey<FormState>();
  DatabaseService databaseService = new DatabaseService();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: HeadingText(
      //   text: 'More',
      //   size: 17.0,
      //   color: Colors.black54,
      // ),
      backgroundColor: Theme.of(context).primaryColorLight,
      content: Container(
        // color: HexColor(appPrimaryColour),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                HeadingText(
                  text: 'Change semeter',
                  size: 15.0,
                  color: Theme.of(context).primaryTextTheme.bodyText1.color,
                ),
                DropDownListForYearData(
                 
                  departmentName: widget.teacherModel.department,
                  onpressed: (val) {
                    setState(() {
                      _newSemester = val;
                    });
                  },
                  selectedYear: _newSemester,
                  courseName: widget.courseName,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        _loading
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Loader(
                  spinnerColor: Colors.black54,
                  color: Theme.of(context).primaryColorLight,
                  size: 24.0,
                ),
              )
            : IconButton(
                icon: Icon(
                  Icons.done,
                ),
                onPressed: () async {
                  if (_formkey.currentState.validate()) {
                    setState(() {
                      _loading = true;
                    });
                    try {
                      // Fluttertoast.showToast(msg: widget.registrationNumber);
                      dynamic result = databaseService.updateStudentSemester(
                          widget.studentUID, _newSemester);
                      if (result != null)
                        Fluttertoast.showToast(msg: 'Updated');
                      else
                        Fluttertoast.showToast(msg: result.toString());
                      setState(() {
                        _loading = false;
                      });
                      Navigator.of(context).pop();
                    } on FirebaseException catch (e) {
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  }
                })
      ],
    );
  }
}
