import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:date_time_picker/date_time_picker.dart';
import '../../../../database/databaseService.dart';
import '../../../../shared/components/constants.dart';
import '../../../../shared/components/loadingWidget.dart';
import 'create_question_screen.dart';

class ExamViewScreen extends StatefulWidget {
  final TeacherModel teacherModel;
  final String className;
  final String semester;
  final String courseName;

  const ExamViewScreen(
      {Key key,
      @required this.teacherModel,
      @required this.className,
      @required this.semester,
      @required this.courseName})
      : super(key: key);
  @override
  _ExamViewScreenState createState() => _ExamViewScreenState();
}

class _ExamViewScreenState extends State<ExamViewScreen> {
  final DatabaseService databaseService = new DatabaseService();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              })
        ],
        centerTitle: true,
        title: HeadingText(
          text: 'Exams',
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
        ),
      ),
      // backgroundColor: HexColor(appPrimaryColour),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(college)
              .doc(widget.teacherModel.department)
              .collection('CourseNames')
              .doc('${widget.courseName}')
              .collection('Semester')
              .doc('${widget.semester}')
              .collection('Classes')
              .doc(widget.className)
              .collection('Exams')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Loader(
                size: 20.0,
                spinnerColor:
                    Theme.of(context).primaryTextTheme.bodyText1.color,
              );
            }
            if (snapshot.data.docs.length == 0) {
              return HeadingText(
                // fontWeight: FontWeight.w500,
                text: 'No exams added yet',
                size: 17.0,
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
              );
            }
            if (snapshot.hasError) {
              return HeadingText(
                textAlign: TextAlign.center,
                // fontWeight: FontWeight.w500,
                text:
                    'Unknown Error! Please Check your Connection and restart the app.',
                size: 17.0,
                color: Colors.red,
              );
            }
            List<DecoratedCard> decoratedContainer = [];
            for (int i = 0; i < snapshot.data.docs.length; ++i) {
              DocumentSnapshot documentSnapshot = snapshot.data.docs[i];
              decoratedContainer.add(
                DecoratedCard(
                  child: Column(
                    children: [
                      HeadingText(
                        alignment: Alignment.topRight,
                        text: 'Total Marks ' +
                                documentSnapshot.data()['TotalMarks'] ??
                            '---',
                        size: 13.0,
                        color:
                            Theme.of(context).primaryTextTheme.bodyText1.color,
                      ),
                      Row(
                        children: [
                          HeadingText(
                            alignment: Alignment.topRight,
                            text: 'Time ' + documentSnapshot.data()['From'] ??
                                '---',
                            size: 13.0,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .bodyText1
                                .color,
                          ),
                          HeadingText(
                            alignment: Alignment.topRight,
                            text:
                                ' - ' + documentSnapshot.data()['To'] ?? '---',
                            size: 13.0,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .bodyText1
                                .color,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      HeadingText(
                        alignment: Alignment.centerLeft,
                        text: documentSnapshot.data()['ExamName'] ?? '---',
                        size: 15.0,
                        color:
                            Theme.of(context).primaryTextTheme.bodyText1.color,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: size.width * 0.6,
                        height: 1.0,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      HeadingText(
                        alignment: Alignment.centerLeft,
                        text: 'Important Notes',
                        size: 15.0,
                        color:
                            Theme.of(context).primaryTextTheme.bodyText1.color,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      HeadingText(
                        alignment: Alignment.centerLeft,
                        text: documentSnapshot.data()['Notes'] ?? '--',
                        size: 13.0,
                        color:
                            Theme.of(context).primaryTextTheme.bodyText1.color,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      TextButton(
                        onPressed: () async {
                          await databaseService.deleteAddedExam(
                              widget.teacherModel.department,
                              widget.courseName,
                              widget.semester,
                              widget.className,
                              documentSnapshot.id);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(builder: (context) {
                      return CreateExamsScreen(
                        teacherModel: widget.teacherModel,
                        className: widget.className,
                        courseName: widget.courseName,
                        semester: widget.semester,
                        examName: documentSnapshot.data()['ExamName'],
                        examID: documentSnapshot.id,
                      );
                    }));
                  },
                ),
              );
            }
            return Container(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: decoratedContainer,
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: HeadingText(
            text: 'Add Exam',
            size: 13.0,
            color: Colors.white,
          ),
          heroTag: 'buttonAddExam',
          splashColor: HexColor('#99b4bf'),
          hoverElevation: 20,
          elevation: 3.0,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Colors.white,
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) {
                  return OpenPopupDialogue(
                    teacherModel: widget.teacherModel,
                    className: widget.className,
                    courseName: widget.courseName,
                    semester: widget.semester,
                  );
                });
          }),
    );
  }
}

class OpenPopupDialogue extends StatefulWidget {
  final TeacherModel teacherModel;
  final String className;
  final String courseName;
  final String semester;

  const OpenPopupDialogue(
      {Key key,
      @required this.teacherModel,
      @required this.className,
      @required this.courseName,
      @required this.semester})
      : super(key: key);
  @override
  _OpenPopupDialogueState createState() => _OpenPopupDialogueState();
}

class _OpenPopupDialogueState extends State<OpenPopupDialogue> {
  String _examName;
  String _totalMarks;

  String _impNotes;
  String _fromTime = '';
  String _toTime = '';

  DatabaseService _databaseService = new DatabaseService();
  bool _loading = false;
  DateTime dateTime = DateTime.now();
  final _formkey = GlobalKey<FormState>();
  bool optionClicked = false;
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return AlertDialog(
      title: HeadingText(
        text: 'Exam Details',
        size: 20.0,
        color: Theme.of(context).primaryTextTheme.bodyText1.color,
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      content: Container(
        // color: HexColor(appPrimaryColour),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RoundedInputField(
                  hintText: 'Name of the Exam',
                  validator: (val) => val.isEmpty ? 'Field Mandatory' : null,
                  onChanged: (val) {
                    _examName = val;
                  },
                ),
                RoundedInputField(
                  hintText: 'Important Notes',
                  // validator: (val) => val.isEmpty ? 'Field Mandatory' : null,
                  onChanged: (val) {
                    _impNotes = val;
                  },
                ),
                RoundedInputField(
                  textInputType: TextInputType.number,
                  hintText: 'Total Marks',
                  validator: (val) => val.isEmpty ? 'Field Mandatory' : null,
                  onChanged: (val) {
                    _totalMarks = val;
                  },
                ),
                // RoundedInputField(
                //   textInputType: TextInputType.number,
                //   hintText: 'Time Limit in Minutes',
                //   validator: (val) => val.isEmpty ? 'Field Mandatory' : null,
                //   onChanged: (val) {
                //     _time = val;
                //   },
                // ),
                DateTimePicker(
                  type: DateTimePickerType.time,

                  //initialValue: _initialValue,
                  icon: Icon(
                    Icons.access_time,
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .selectedItemColor,
                  ),
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.bodyText1.color,
                  ),
                  timeLabelText: "From",
                  use24HourFormat: true,
                  //locale: Locale('en', 'US'),
                  onChanged: (val) {
                    setState(() => _fromTime = val);
                  },
                ),
                DateTimePicker(
                  type: DateTimePickerType.time,

                  //initialValue: _initialValue,
                  icon: Icon(
                    Icons.access_time,
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .selectedItemColor,
                  ),

                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.bodyText1.color,
                  ),
                  timeLabelText: "To",
                  use24HourFormat: true,
                  //locale: Locale('en', 'US'),
                  onChanged: (val) {
                    setState(() => _toTime = val);
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
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor,
                ),
                onPressed: () async {
                  if (_formkey.currentState.validate() &&
                      _fromTime.isNotEmpty &&
                      _toTime.isNotEmpty) {
                    setState(() {
                      _loading = true;
                    });
                    dynamic result = await _databaseService.addNewExam(
                        widget.teacherModel.department,
                        widget.courseName,
                        widget.className,
                        widget.semester,
                        dateTime.toString(),
                        _examName,
                        _totalMarks,
                        _impNotes,
                        _fromTime,
                        _toTime);
                    if (result != null) {
                      Fluttertoast.showToast(msg: 'not Added, unknown error');
                      setState(() {
                        _loading = false;
                      });
                    } else {
                      Fluttertoast.showToast(msg: 'Added');
                      setState(() {
                        _loading = false;
                      });
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  }
                })
      ],
    );
  }
}
