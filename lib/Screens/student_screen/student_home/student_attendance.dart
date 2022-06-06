import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../shared/components/constants.dart';
import '../../../shared/components/loadingWidget.dart';

class StudentAttendance extends StatefulWidget {
  final StudentModel studentModel;
  final String className;

  const StudentAttendance(
      {Key key, @required this.studentModel, @required this.className})
      : super(key: key);
  @override
  _StudentAttendanceState createState() => _StudentAttendanceState();
}

//implement charts
class _StudentAttendanceState extends State<StudentAttendance> {
  List<DocumentSnapshot> dates = [];

  DateTime dateTime = DateTime.now();
  Future _getDates() async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore
          .collection('myCollege')
          .doc(widget.studentModel.department)
          .collection('CourseNames')
          .doc(widget.studentModel.course)
          .collection('Semester')
          .doc(widget.studentModel.semester)
          .collection('Classes')
          .doc(widget.className)
          .collection('Attendance')
          .get()
          .then((snapshot) {
        dates = snapshot.docs.toList();
      });
      return dates.length;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

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
          text: 'Attendance',
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
        ),
      ),
      // backgroundColor: HexColor(appPrimaryColour),
      body: SafeArea(
        child: Container(
          child: FutureBuilder(
            future: _getDates(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loader(
                  color: Theme.of(context).primaryColor,
                  size: 20.0,
                  spinnerColor: Colors.black54,
                );
              } else if (snapshot.data == 0) {
                return Container(
                  color: Theme.of(context).primaryColor,
                  child: HeadingText(
                    text: 'No Attendance records',
                    size: 17.0,
                    color: Theme.of(context).primaryTextTheme.bodyText1.color,
                  ),
                );
              } else if (snapshot.hasError) {
                return HeadingText(
                  text: 'Unknown error occured',
                  size: 17.0,
                  color: Colors.black87,
                );
              } else if (!snapshot.hasError) {
                return buildListView(size);
              }
              return Loader(
                  color: Theme.of(context).primaryColor,
                  size: 34.0,
                  spinnerColor: Colors.black54);
            },
          ),
        ),
      ),
    );
  }

  ListView buildListView(Size size) {
    return ListView.builder(
      itemCount: dates.length,
      itemBuilder: (BuildContext context, index) {
        return StatusCard(
            className: widget.className,
            studentModel: widget.studentModel,
            date: dates[index].id,
            status: dates[index].data()['Status']);
      },
    );
  }
}

class StatusCard extends StatefulWidget {
  final String date;
  final String status;
  final String className;
  final StudentModel studentModel;

  const StatusCard({
    Key key,
    @required this.date,
    @required this.status,
    @required this.className,@required this.studentModel,
  }) : super(key: key);
  @override
  _StatusCardState createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard> {
  DocumentSnapshot status;
  Future _getStatus(String date) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore
          .collection('myCollege')
          .doc(widget.studentModel.department)
          .collection('CourseNames')
          .doc(widget.studentModel.course)
          .collection('Semester')
          .doc(widget.studentModel.semester)
          .collection('Classes')
          .doc(widget.className)
          .collection('Attendance')
          .doc(date)
          .collection('Status')
          .doc(widget.studentModel.regNumber)
          .get()
          .then((snapshot) {
        status = snapshot;
      });
      return status.exists;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.5),
      child: Table(
          defaultColumnWidth: FixedColumnWidth(120.0),
          border: TableBorder.all(
              color: Theme.of(context).primaryTextTheme.bodyText1.color,
              style: BorderStyle.solid,
              width: 2),
          children: [
            TableRow(children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.date.replaceAll('_', '-')),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder(
                      future: _getStatus(widget.date),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Loader(
                              color: Theme.of(context).primaryColorLight,
                              size: 15.0,
                              spinnerColor: Theme.of(context).primaryTextTheme.bodyText1.color);
                        } else if (!snapshot.data) {
                          return Container(
                            child: HeadingText(
                              text: 'Not Marked',
                              size: 15.0,
                              color: Theme.of(context).primaryTextTheme.bodyText1.color,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return HeadingText(
                            text: 'Unknown error occured',
                            size: 17.0,
                            color: Theme.of(context).primaryTextTheme.bodyText1.color,
                          );
                        } else if (snapshot.data) {
                          return HeadingText(
                            text: status.data()['Status'],
                            size: 15.0,
                            color: status.data()['Status'] == 'Present'
                                ? Colors.green
                                : Colors.red,
                          );
                        }
                        return Loader(
                            color: Theme.of(context).primaryColor,
                            size: 15.0,
                            spinnerColor: Colors.black54);
                      },
                    ),
                  ),
                ],
              ),
            ]),
          ]),
    );
  }

  showStatusAlertDialog(BuildContext context, String status) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // backgroundColor: HexColor(appPrimaryColour),
      title: HeadingText(
        text: 'Status',
        size: 17.0,
        color: Theme.of(context).primaryTextTheme.bodyText1.color,
      ),

      content: HeadingText(
        text: widget.date,
        size: 17.0,
        color: Theme.of(context).primaryTextTheme.bodyText1.color,
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
