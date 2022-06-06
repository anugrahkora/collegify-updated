import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/database/databaseService.dart';
import 'package:collegify/models/user_model.dart';
import 'package:collegify/shared/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

class AssignMarks extends StatefulWidget {
  final TeacherModel teacherModel;
  final DocumentSnapshot questionDocumentSnapshot;
  final String className;
  final String semester;
  final String courseName;
  final String examID;
  final String questionID;
  final String marks;

  const AssignMarks({
    Key key,
    @required this.teacherModel,
    @required this.className,
    @required this.semester,
    @required this.courseName,
    @required this.examID,
    @required this.questionID,
    @required this.marks,
    @required this.questionDocumentSnapshot,
  }) : super(key: key);
  @override
  _AssignMarksState createState() => _AssignMarksState();
}

class _AssignMarksState extends State<AssignMarks> {
  bool _loading = false;
  String _marks;

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          RoundedInputField(
            color: Colors.white,
            prefixIcon: Icon(Icons.edit),
            // textInputType: TextInputType.number,
            hintText: 'Marks obtained',
            validator: (val) => val.isEmpty ? 'Enter marks' : null,
            onChanged: (val) {
              _marks = val;
            },
          ),
          RoundedButton(
            loading: _loading,
            color: Theme.of(context).colorScheme.secondary,
            text: 'Assign',
            onPressed: () {
              if (_formkey.currentState.validate()) {
                try {
                  // setState(() {
                  //   _loading = true;
                  // });
                  dynamic result = DatabaseService().assignMarkToAnswer(
                      widget.teacherModel.department,
                      widget.courseName,
                      widget.className,
                      widget.semester,
                      widget.examID,
                      widget.questionID,
                      widget.questionDocumentSnapshot.id,
                      _marks);

                  if (result != null)
                    Fluttertoast.showToast(msg: 'assigned');
                  else
                    Fluttertoast.showToast(msg: 'Failed');
                } on FirebaseException catch (e) {
                  Fluttertoast.showToast(msg: e.message);
                }
                // setState(() {
                //   _loading = false;
                // });
              }
            },
          ),
        ],
      ),
    );
  }
}
