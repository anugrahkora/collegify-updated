import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../models/user_model.dart';
import '../../../../shared/components/constants.dart';
import '../../../../shared/components/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class StudentAttendanceViewScreen extends StatefulWidget {
  final TeacherModel teacherModel;
  final String courseName;
  final String className;
  final String semester;

  const StudentAttendanceViewScreen(
      {Key key,
      @required this.teacherModel,
      @required this.courseName,
      @required this.className,
      @required this.semester})
      : super(key: key);
  @override
  _StudentAttendanceViewScreenState createState() =>
      _StudentAttendanceViewScreenState();
}

class _StudentAttendanceViewScreenState
    extends State<StudentAttendanceViewScreen> {
  DateTime dateTime = DateTime.now();
  List<DocumentSnapshot> studentNames = [];
  List<DocumentSnapshot> studentAttendance = [];

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<AttendanceStatusModel> attendanceStatus = [];

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
      checkAttendance();
    }
  }

  // Future getStudentAttendance() async {
  //   try {
  //     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  //     await FirebaseFirestore.instance
  //         .collection('college')
  //         .doc('${widget.documentSnapshot.data()['University']}')
  //         .collection('CollegeNames')
  //         .doc('${widget.documentSnapshot.data()['College']}')
  //         .collection('DepartmentNames')
  //         .doc('${widget.documentSnapshot.data()['Department']}')
  //         .collection('CourseNames')
  //         .doc('${widget.courseName}')
  //         .collection('Semester')
  //         .doc('${widget.semester}')
  //         .collection('Classes')
  //         .doc(widget.className)
  //         .collection('Attendance')
  //         .doc(dateTime.toString().substring(0, 10).replaceAll('-', '_'))
  //         .collection('Status')
  //         .get()
  //         .then((snapshot) {
  //       studentAttendance = snapshot.docs.toList();
  //     });

  //     return studentAttendance;
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: e.toString());
  //   }
  // }

  Future<bool> checkAttendance() async {
    var collectionRef = FirebaseFirestore.instance
        .collection(college)
        
        .doc(widget.teacherModel.department)
        .collection('CourseNames')
        .doc('${widget.courseName}')
        .collection('Semester')
        .doc('${widget.semester}')
        .collection('Classes')
        .doc(widget.className)
        .collection('Attendance');

    var doc = await collectionRef
        .doc(dateTime.toString().substring(0, 10).replaceAll('-', '_'))
        .get();

    return doc.exists;
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: HeadingText(
          text: ' Attendance registry ' +
              ' ' +
              '( ${dateTime.toString().substring(0, 10)} )',
          size: 17.0,
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'changeDate',
        splashColor: HexColor('#99b4bf'),
        hoverElevation: 20,
        elevation: 3.0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: () async {
          selectDate(context);
        },
        child: Icon(Icons.date_range),
      ),
      // backgroundColor: HexColor(appPrimaryColour),
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(college)
               
                .doc(widget.teacherModel.department)
                .collection('CourseNames')
                .doc('${widget.courseName}')
                .collection('Semester')
                .doc('${widget.semester}')
                .collection('Classes')
                .doc(widget.className)
                .collection('Attendance')
                .doc(dateTime.toString().substring(0, 10).replaceAll('-', '_'))
                .collection('Status')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loader(
                    color: Theme.of(context).primaryColor,
                    size: 34.0,
                    spinnerColor: Colors.black54);
              } else if (snapshot.data.docs.length == 0) {
                return Center(
                  child: HeadingText(
                    text: 'No Attendance Marked on this date',
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
              List<Container> decoratedContainer = [];
              for (int i = 0; i < snapshot.data.docs.length; ++i) {
                DocumentSnapshot documentSnapshot = snapshot.data.docs[i];
                decoratedContainer.add(
                  Container(
                    margin: EdgeInsets.all(1.0),
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
                                  child: Text(documentSnapshot.id),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(documentSnapshot.data()['Name']),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      Text(documentSnapshot.data()['Status']),
                                ),
                              ],
                            ),
                          ]),
                        ]),
                  ),
                );
              }
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: Table(
                        defaultColumnWidth: FixedColumnWidth(120.0),
                        border: TableBorder.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 2),
                        children: [
                          TableRow(children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Roll Number',
                                  ),
                                ),
                              ],
                            ),
                            Column(children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Name',
                                  ),
                                ),
                              )
                            ]),
                            Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Status',
                                ),
                              )
                            ]),
                          ]),
                        ]),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: decoratedContainer,
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
