import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/database/databaseService.dart';
import 'package:collegify/models/user_model.dart';
import 'package:collegify/shared/components/constants.dart';
import 'package:collegify/shared/components/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

class OpenAssignMarksPopup extends StatefulWidget {
  final TeacherModel teacherModel;
  final DocumentSnapshot questionDocumentSnapshot;
  final String className;
  final String semester;
  final String courseName;
  final String examID;
  final String questionID;
  final String maximumMark;

  const OpenAssignMarksPopup(
      {Key key,
      @required this.teacherModel,
      @required this.questionDocumentSnapshot,
      @required this.className,
      @required this.semester,
      @required this.courseName,
      @required this.examID,
      @required this.questionID,
      @required this.maximumMark})
      : super(key: key);
  @override
  _OpenAssignMarksPopupState createState() => _OpenAssignMarksPopupState();
}

class _OpenAssignMarksPopupState extends State<OpenAssignMarksPopup> {
  String _mark;
  DateTime dateTime = DateTime.now();
  bool _loading = false;
  final _formkey = GlobalKey<FormState>();
  bool optionClicked = false;
  // DatabaseService _databaseService = new DatabaseService();
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return AlertDialog(
      title: HeadingText(
          text: 'Assign Marks',
          size: 17.0,
          color: Theme.of(context).primaryTextTheme.bodyText1.color),
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
                    text: 'Maximum Marks' + ' ' + widget.maximumMark,
                    size: 15.0,
                    color: Theme.of(context).primaryTextTheme.bodyText1.color),
                RoundedInputField(
                  textInputType: TextInputType.number,
                  hintText: 'Score',
                  validator: (val) => val.isEmpty ||
                          (double.parse(val.toString())) >
                              (double.parse(widget.maximumMark))
                      ? 'Invalid mark'
                      : null,
                  onChanged: (val) {
                    _mark = val;
                  },
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
                    try {
                      setState(() {
                        _loading = true;
                      });
                      dynamic result = DatabaseService().assignMarkToAnswer(
                       
                          widget.teacherModel.department,
                          widget.courseName,
                          widget.className,
                          widget.semester,
                          widget.examID,
                          widget.questionID,
                          widget.questionDocumentSnapshot.id,
                          _mark);

                      if (result != null)
                        Fluttertoast.showToast(msg: 'assigned');
                      else
                        Fluttertoast.showToast(msg: 'Failed');
                      Navigator.pop(context);
                    } on FirebaseException catch (e) {
                      Fluttertoast.showToast(msg: e.message);
                    }
                  }
                })
      ],
    );
  }
}
