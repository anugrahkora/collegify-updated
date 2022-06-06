import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/models/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../database/databaseService.dart';
import '../../../../shared/components/constants.dart';
import '../../../../shared/components/loadingWidget.dart';

class StudentQuestionsViewScreen extends StatefulWidget {
  // final DocumentSnapshot documentSnapshot;
  final String className;
  final String examID;
  final StudentModel studentModel;
  final String examName;
  final String totalMarks;

  const StudentQuestionsViewScreen({
    Key key,
    // @required this.documentSnapshot,
    @required this.className,
    @required this.examID,
    @required this.studentModel,
    @required this.examName,
    @required this.totalMarks,
  }) : super(key: key);
  @override
  _StudentQuestionsViewScreenState createState() =>
      _StudentQuestionsViewScreenState();
}

class _StudentQuestionsViewScreenState
    extends State<StudentQuestionsViewScreen> {
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black54, //change your color here
          ),
          backgroundColor: Theme.of(context).primaryColorLight,
          title: HeadingText(
            alignment: Alignment.topLeft,
            text: 'Questions',
            color: Theme.of(context).primaryTextTheme.bodyText1.color,
          ),
        ),
        // bottomNavigationBar: Container(
        //   height: size.height * 0.075,
        //   color: HexColor(appPrimaryColourLight),
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: [
        //         Text('Total'),
        //         Text(widget.totalMarks),
        //       ],
        //     ),
        //   ),
        // ),
        // backgroundColor: HexColor(appPrimaryColour),
        body: BuildQuestionCard(
            examName: widget.examName,
            studentModel: widget.studentModel,
            className: widget.className,
            examID: widget.examID));
  }
}

class BuildQuestionCard extends StatefulWidget {
  final StudentModel studentModel;
  final String className;
  final String examID;
  final String examName;
  const BuildQuestionCard(
      {Key key,
      @required this.className,
      @required this.examID,
      @required this.studentModel,
      @required this.examName})
      : super(key: key);
  @override
  _BuildQuestionCardState createState() => _BuildQuestionCardState();
}

class _BuildQuestionCardState extends State<BuildQuestionCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('myCollege')
          .doc('${widget.studentModel.department}')
          .collection('CourseNames')
          .doc('${widget.studentModel.course}')
          .collection('Semester')
          .doc('${widget.studentModel.semester}')
          .collection('Classes')
          .doc(widget.className)
          .collection('Exams')
          .doc(widget.examID)
          .collection('Questions')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loader(
            size: 20.0,
            spinnerColor: Colors.black54,
          );
        }
        if (snapshot.data.docs.length == 0) {
          return HeadingText(
            // fontWeight: FontWeight.w500,
            text: 'No Questions added yet!',
            size: 17.0,
            color: Theme.of(context).primaryTextTheme.bodyText1.color,
          );
        }
        if (snapshot.hasError) {
          return HeadingText(
            // fontWeight: FontWeight.w500,
            text:
                'Unknown Error! Please Check your Connection and restart the app.',
            size: 20.0,
            color: Colors.red,
          );
        }

        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return DecoratedCard(
              onTap: () {},
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: HeadingText(
                          alignment: Alignment.topCenter,
                          text: '${index + 1}.',
                          size: 17.0,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .bodyText1
                              .color,
                        ),
                      ),
                      Container(
                        child: HeadingText(
                          alignment: Alignment.topCenter,
                          text:
                              'Marks' + ' ' + snapshot.data.docs[index]['Mark'],
                          size: 15.0,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .bodyText1
                              .color,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: size.width * 0.8,
                    child: HeadingText(
                      alignment: Alignment.centerLeft,
                      text: snapshot.data.docs[index]['Question'],
                      size: 17.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    width: size.width * 0.75,
                    height: 1.0,
                    color: Theme.of(context).primaryTextTheme.bodyText1.color,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  HeadingText(
                    alignment: Alignment.centerLeft,
                    text: 'Your Answer',
                    size: 13.0,
                    color: Theme.of(context).primaryTextTheme.bodyText1.color,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 15.0),
                      child: buildSubmitionStatus(
                          snapshot.data.docs[index], index),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  FutureBuilder<bool> buildSubmitionStatus(
      DocumentSnapshot documentSnapshot, int i) {
    return FutureBuilder(
      future: DatabaseService().checkIfAnswerDocExists(
          widget.studentModel.department,
          widget.studentModel.course,
          widget.studentModel.semester,
          widget.className,
          widget.examID,
          documentSnapshot.id,
          widget.studentModel.regNumber),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.centerLeft,
            child: Loader(
                color: Theme.of(context).primaryColorLight,
                size: 15.0,
                spinnerColor: Colors.black54),
          );
        } else if (!snapshot.data) {
          return NotSubmittedScreen(
              examName: widget.examName,
              className: widget.className,
              examID: widget.examID,
              studentModel: widget.studentModel,
              documentSnapshot: documentSnapshot,
              i: i);
        } else if (snapshot.hasError) {
          return HeadingText(
            alignment: Alignment.centerLeft,
            text: 'Unknown error occured',
            size: 20.0,
            color: Colors.black87,
          );
        } else if (snapshot.data) {
          return buildSubmittedAnswer(documentSnapshot);
        }
        return Loader(
            color: Theme.of(context).primaryColorLight,
            size: 15.0,
            spinnerColor: Colors.black54);
      },
    );
  }

  StreamBuilder<DocumentSnapshot> buildSubmittedAnswer(
      DocumentSnapshot documentSnapshot) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('myCollege')
            .doc(widget.studentModel.department)
            .collection('CourseNames')
            .doc(widget.studentModel.course)
            .collection('Semester')
            .doc(widget.studentModel.semester)
            .collection('Classes')
            .doc(widget.className)
            .collection('Exams')
            .doc(widget.examID)
            .collection('Questions')
            .doc(documentSnapshot.id)
            .collection('Answer')
            .doc(widget.studentModel.regNumber)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              alignment: Alignment.centerLeft,
              child: Loader(
                  color: Theme.of(context).primaryColorLight,
                  size: 15.0,
                  spinnerColor: Colors.black54),
            );
          }
          return Column(
            children: [
              HeadingText(
                alignment: Alignment.centerLeft,
                text: snapshot.data.data()['Answer'] ?? '---',
                size: 13.0,
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
              ),
              SizedBox(
                height: 10.0,
              ),
              HeadingText(
                alignment: Alignment.centerLeft,
                text: 'Marks' + ' ' + snapshot.data.data()['Marks'] ?? '---',
                size: 15.0,
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
              ),
            ],
          );
        });
  }
}

class NotSubmittedScreen extends StatefulWidget {
  final String className;
  final String examID;
  final StudentModel studentModel;
  final DocumentSnapshot documentSnapshot;
  final int i;
  final String examName;

  const NotSubmittedScreen({
    Key key,
    @required this.className,
    @required this.examID,
    @required this.studentModel,
    @required this.documentSnapshot,
    @required this.i,
    @required this.examName,
  }) : super(key: key);

  @override
  _NotSubmittedScreenState createState() => _NotSubmittedScreenState();
}

class _NotSubmittedScreenState extends State<NotSubmittedScreen> {
  UploadTask uploadTask;
  _startUpload() {
    String _filePath =
        '${widget.studentModel.department}/${widget.studentModel.course}/${widget.studentModel.semester}/${widget.className}/examFiles/${widget.examName}/${widget.studentModel.regNumber}/${DateTime.now()}';
    if (_documentFile != null) {
      try {
        final _storage = FirebaseStorage.instance.ref().child(_filePath);

        setState(() {
          uploadTask = _storage.putFile(_documentFile);
        });
      } catch (e) {}
    }
  }

  File _documentFile;
  Future<void> _pickFile() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'png'],
      );

      if (result != null) {
        setState(() {
          _documentFile = File(result.files.single.path);
        });
      } else {
        Fluttertoast.showToast(msg: 'No file selected');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'No file selected');
    }
  }

  void clear() {
    setState(() {
      _documentFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColorLight,
        child: Column(
          children: [
            HeadingText(
              // alignment: Alignment.centerLeft,
              text: 'Not Submitted',
              size: 13.0,
              color: Theme.of(context).primaryTextTheme.bodyText1.color,
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.secondary,
              )),
              child: HeadingText(
                // alignment: Alignment.centerLeft,
                text: 'Press to type',
                size: 13.0,
                color: Theme.of(context).primaryColorLight,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return OpenPopupDialogue(
                        studentModel: widget.studentModel,
                        className: widget.className,
                        examID: widget.examID,
                        questionID: widget.documentSnapshot.id,
                        questionNumber: '${widget.i + 1}',
                      );
                    });
              },
            ),
          ],
        ));
  }
}

class OpenPopupDialogue extends StatefulWidget {
  final StudentModel studentModel;
  final String className;
  final String examID;
  final String questionID;
  final String questionNumber;

  const OpenPopupDialogue({
    Key key,
    @required this.studentModel,
    @required this.className,
    @required this.questionID,
    @required this.examID,
    @required this.questionNumber,
  }) : super(key: key);
  @override
  _OpenPopupDialogueState createState() => _OpenPopupDialogueState();
}

class _OpenPopupDialogueState extends State<OpenPopupDialogue> {
  String _answer;
  DateTime _dateTime = DateTime.now();
  bool _loading = false;
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      title: HeadingText(
        text: 'Answer ' + widget.questionNumber,
        size: 20.0,
        color: Colors.black54,
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      content: Container(
        width: size.width * 0.8,
        // color: HexColor(appPrimaryColour),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: TextFormField(
              validator: (val) => val.isEmpty ? '* Mandatory' : null,
              keyboardType: TextInputType.multiline,
              maxLines: 100,
              onChanged: (val) {
                _answer = val;
              },
              decoration: InputDecoration(
                hintStyle:
                    GoogleFonts.montserrat(color: Colors.black54, fontSize: 16),
                hintText: 'Answer (Max 100 lines)',
                border: InputBorder.none,
              ),
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
                    dynamic result = await DatabaseService().addNewAnswer(
                        widget.studentModel.department,
                        widget.studentModel.course,
                        widget.className,
                        widget.studentModel.semester,
                        widget.examID,
                        widget.questionID,
                        widget.studentModel.regNumber,
                        widget.studentModel.name,
                        _answer,
                        _dateTime.toString());

                    if (result != null) {
                      Fluttertoast.showToast(msg: 'Error');
                      setState(() {
                        _loading = false;
                      });
                    } else {
                      Fluttertoast.showToast(msg: 'Submitted');
                      setState(() {
                        _loading = false;
                      });
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                    try {} catch (e) {
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  }
                })
      ],
    );
  }
}
