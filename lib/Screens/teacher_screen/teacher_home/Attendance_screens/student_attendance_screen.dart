import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/Screens/teacher_screen/teacher_home/editStudentScreen/editStudent.dart';
import 'package:collegify/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../database/databaseService.dart';
import '../../../../shared/components/constants.dart';
import '../../../../shared/components/loadingWidget.dart';

class StudentAttendance extends StatefulWidget {
  final TeacherModel teacherModel;
  final String courseName;
  final String className;
  final String semester;

  const StudentAttendance({
    Key key,
    @required this.teacherModel,
    this.className,
    this.semester,
    this.courseName,
  }) : super(key: key);
  @override
  _StudentAttendanceState createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  List<DocumentSnapshot> studentNames = [];
  DocumentSnapshot documentSnapshot;
  IconData radioButton = Icons.radio_button_off_rounded;
  DateTime dateTime = DateTime.now();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String studentUid;

// to select the date
  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030));
    if (picked != null && picked != dateTime) {
      setState(() {
        dateTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('Department', isEqualTo: widget.teacherModel.department)
          .where('Course', isEqualTo: widget.courseName)
          .where('Semester', isEqualTo: widget.semester)
          .where('Role', isEqualTo: 'student')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader(
              color: Theme.of(context).primaryColor,
              size: 34.0,
              spinnerColor: Colors.black54);
        } else if (snapshot.data.docs.length == 0) {
          return Container(
            color: Theme.of(context).primaryColor,
            child: HeadingText(
              text: 'No Student records',
              size: 17.0,
              color: Theme.of(context).primaryTextTheme.bodyText1.color,
            ),
          );
        } else if (snapshot.hasError) {
          return HeadingText(
            text: 'Unknown error occured',
            size: 17.0,
            color: Theme.of(context).primaryTextTheme.bodyText1.color,
          );
        }
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ImageIcon(
                AssetImage('assets/icons/iconStudent.png'),
              ),
            ),
            centerTitle: true,
            title: HeadingText(
              text: dateTime.toString().substring(0, 11),
              size: 17.0,
              color: Theme.of(context).primaryTextTheme.bodyText1.color,
            ),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.edit,
                  ),
                  onPressed: () {
                    selectDate(context);
                  })
            ],
          ),
          // backgroundColor: HexColor(appPrimaryColour),
          body: SafeArea(
            child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, index) {
                return ListSwitchTileSelect(
                  name: snapshot.data.docs[index]['Name'],
                  rollNumber: snapshot.data.docs[index]['Registration_Number'],
                  studentCurrentCourse: snapshot.data.docs[index]['Course'],
                  studentCurrentSemester: snapshot.data.docs[index]['Semester'],
                  studentUID: snapshot.data.docs[index].id,
                  teacherModel: widget.teacherModel,
                  courseName: widget.courseName,
                  className: widget.className,
                  semester: widget.semester,
                  dateTime:
                      dateTime.toString().substring(0, 10).replaceAll('-', '_'),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class ListSwitchTileSelect extends StatefulWidget {
  final String name;
  final String dateTime;
  final TeacherModel teacherModel;
  final String courseName;
  final String className;
  final String semester;
  final String rollNumber;
  final String studentCurrentSemester;
  final String studentCurrentCourse;
  final String studentUID;

  const ListSwitchTileSelect({
    Key key,
    this.name,
    this.dateTime,
    @required this.teacherModel,
    this.courseName,
    this.className,
    this.semester,
    @required this.rollNumber,
    @required this.studentCurrentSemester,
    @required this.studentCurrentCourse,
    @required this.studentUID,
  }) : super(key: key);
  @override
  _ListSwitchTileSelectState createState() => _ListSwitchTileSelectState();
}

class _ListSwitchTileSelectState extends State<ListSwitchTileSelect> {
  bool _clickedPresent = false;
  bool _clickedAbsent = false;
  DatabaseService _databaseService = new DatabaseService();
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return DecoratedCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeadingText(
                alignment: Alignment.centerLeft,
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
                text: widget.name,
                size: 15,
              ),
              PopupMenuButton(
                enableFeedback: true,
                child: Center(
                    child: Icon(
                  Icons.more_vert,
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor,
                )),
                itemBuilder: (context) {
                  return List.generate(1, (i) {
                    return PopupMenuItem(
                      child: TextButton(
                          child: HeadingText(
                            // fontWeight: FontWeight.w500,
                            alignment: Alignment.topLeft,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .bodyText1
                                .color,
                            text: 'More',
                            size: 15,
                          ),
                          onPressed: () async {
                            try {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                builder: (context) => EditStudentScreen(
                                  studentCurrentCourse:
                                      widget.studentCurrentCourse,
                                  studentCurrentSemeter:
                                      widget.studentCurrentSemester,
                                  studentRollNumber: widget.rollNumber,
                                  studentUID: widget.studentUID,
                                  studentName: widget.name,
                                  teacherModel: widget.teacherModel,
                                  className: widget.className,
                                  courseName: widget.courseName,
                                  semester: widget.semester,
                                ),
                              ));
                            } catch (e) {
                              Fluttertoast.showToast(msg: e.message);
                            }
                          }),
                    );
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeadingText(
                alignment: Alignment.centerLeft,
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
                text: widget.rollNumber,
                size: 15,
              ),
              Container(
                child: Row(
                  children: [
                    TextButton(
                      child: Icon(
                        Icons.close,
                        color: _clickedAbsent ? Colors.red : Colors.grey,
                      ),
                      onPressed: () async {
                        dynamic result =
                            await _databaseService.markAttendanceAbsent(
                                widget.teacherModel.department,
                                widget.courseName,
                                widget.className,
                                widget.semester,
                                widget.dateTime,
                                widget.name,
                                widget.rollNumber);
                        if (result != null) {
                          Fluttertoast.showToast(msg: result);
                        } else {
                          Fluttertoast.showToast(
                              msg: '${widget.name} is marked absent ');
                        }
                        setState(() {
                          _clickedAbsent = !_clickedAbsent;
                          _clickedPresent = false;
                        });
                        Fluttertoast.showToast(msg: 'Absent');
                      },
                    ),
                    TextButton(
                      style: _clickedPresent
                          ? ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  // side: BorderSide(color: Colors.red),
                                ),
                              ),
                            )
                          : ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(color: Colors.green),
                                ),
                              ),
                            ),
                      child: Icon(
                        Icons.done,
                        color: _clickedPresent ? Colors.white : Colors.green,
                      ),
                      onPressed: () async {
                        dynamic result =
                            await _databaseService.markAttendancePresent(
                          widget.teacherModel.department,
                          widget.courseName,
                          widget.className,
                          widget.semester,
                          widget.dateTime,
                          widget.name,
                          widget.rollNumber,
                        );
                        if (result != null) {
                          Fluttertoast.showToast(msg: result);
                        } else {
                          Fluttertoast.showToast(
                              msg: '${widget.name} is marked present ');
                          setState(() {
                            _clickedPresent = !_clickedPresent;
                            _clickedAbsent = false;
                          });
                        }

                        // Fluttertoast.showToast(msg: 'Present');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      onTap: () {},
    );
  }
}
