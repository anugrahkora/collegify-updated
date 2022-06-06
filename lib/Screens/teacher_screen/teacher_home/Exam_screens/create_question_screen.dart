import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/Screens/teacher_screen/teacher_home/Exam_screens/view_answers.dart';
import 'package:collegify/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../database/databaseService.dart';
import '../../../../shared/components/constants.dart';
import '../../../../shared/components/loadingWidget.dart';

class CreateExamsScreen extends StatefulWidget {
  final TeacherModel teacherModel;
  final String className;
  final String semester;
  final String courseName;
  final String examName;
  final String examID;

  const CreateExamsScreen({
    Key key,
    @required this.teacherModel,
    @required this.className,
    @required this.semester,
    @required this.courseName,
    @required this.examName,
    @required this.examID,
  }) : super(key: key);
  _CreateExamsScreenState createState() => _CreateExamsScreenState();
}

class _CreateExamsScreenState extends State<CreateExamsScreen> {
  List<DecoratedContainer> questionCard = [];
  final DatabaseService databaseService = new DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black54, //change your color here
          ),
          backgroundColor: Colors.white,
          title: HeadingText(
            alignment: Alignment.centerLeft,
            text: widget.examName,
            size: 17.0,
            color: Theme.of(context).primaryTextTheme.bodyText1.color,
          )),
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
              .doc(widget.examID)
              .collection('Questions')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
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
            List<DecoratedCard> decoratedContainer = [];
            for (int i = 0; i < snapshot.data.docs.length; ++i) {
              DocumentSnapshot documentSnapshot = snapshot.data.docs[i];
              decoratedContainer.add(
                DecoratedCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: HeadingText(
                              text: '${i + 1}.',
                              size: 17.0,
                              color: Theme.of(context).primaryTextTheme.bodyText1.color,
                            ),
                          ),
                          Container(
                            child: HeadingText(
                              text: 'Mark' +
                                  ' ' +
                                  documentSnapshot.data()['Mark'],
                              size: 13.0,
                              color: Theme.of(context).primaryTextTheme.bodyText1.color,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: HeadingText(
                          alignment: Alignment.centerLeft,
                          text: documentSnapshot.data()['Question'],
                          size: 15.0,
                          color: Theme.of(context).primaryTextTheme.bodyText1.color,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      TextButton(
                        onPressed: () async {
                          await databaseService.deleteAddedQuestion(
                              widget.teacherModel.department,
                              widget.courseName,
                              widget.semester,
                              widget.className,
                              widget.examID,
                              documentSnapshot.id);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(builder: (context) {
                      return ViewAnswersScreen(
                        teacherModel: widget.teacherModel,
                        className: widget.className,
                        courseName: widget.courseName,
                        semester: widget.semester,
                        examID: widget.examID,
                        marks: documentSnapshot.data()['Mark'],
                        questionID: documentSnapshot.id,
                      );
                    }));
                  },
                ),
              );
            }
            return Container(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: decoratedContainer,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: HeadingText(
            text: 'Add Question',
            size: 15.0,
            color: Colors.white,
          ),
          heroTag: 'buttonAddQuestion',
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
                    courseName: widget.courseName,
                    className: widget.className,
                    semester: widget.semester,
                    examName: widget.examName,
                    examID: widget.examID,
                  );
                });
          }),
    );
  }
}

class OpenPopupDialogue extends StatefulWidget {
  final TeacherModel teacherModel;
  final String className;
  final String semester;
  final String courseName;
  final String examName;
  final String examID;

  const OpenPopupDialogue(
      {Key key,
      @required this.teacherModel,
      @required this.className,
      @required this.semester,
      @required this.courseName,
      @required this.examName,
      @required this.examID})
      : super(key: key);
  @override
  _OpenPopupDialogueState createState() => _OpenPopupDialogueState();
}

class _OpenPopupDialogueState extends State<OpenPopupDialogue> {
  String _question;
  String _mark;
  DateTime dateTime = DateTime.now();
  bool _loading = false;
  final _formkey = GlobalKey<FormState>();
  bool optionClicked = false;
  DatabaseService _databaseService = new DatabaseService();
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return AlertDialog(
      title: HeadingText(
        text: 'Add Question',
        size: 20.0,
        color: Colors.black54,
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
                  hintText: 'Question',
                  validator: (val) => val.isEmpty ? 'Field Mandatory' : null,
                  onChanged: (val) {
                    _question = val;
                  },
                ),
                RoundedInputField(
                  textInputType: TextInputType.number,
                  hintText: 'Mark',
                  validator: (val) => val.isEmpty ? 'Field Mandatory' : null,
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
                    dynamic result = await _databaseService.addNewQuestion(
                        widget.teacherModel.department,
                        widget.courseName,
                        widget.className,
                        widget.semester,
                        dateTime.toString(),
                        widget.examID,
                        _question,
                        _mark);
                    if (result != null)
                      Fluttertoast.showToast(msg: result.toString());
                    else
                      Fluttertoast.showToast(msg: 'Added');
                    Navigator.pop(context);
                  }
                })
      ],
    );
  }
}

class OpenDeletePopUp extends StatefulWidget {
  final String questionNumber;

  const OpenDeletePopUp({Key key, @required this.questionNumber})
      : super(key: key);
  @override
  _OpenDeletePopUpState createState() => _OpenDeletePopUpState();
}

class _OpenDeletePopUpState extends State<OpenDeletePopUp> {
  bool _loading = false;
  // final _formkey = GlobalKey<FormState>();
  bool optionClicked = false;
  // DatabaseService _databaseService = new DatabaseService();
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return AlertDialog(
      title: HeadingText(
        text: 'Delete ' + widget.questionNumber + ' ?',
        size: 20.0,
        color: Colors.black54,
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      actions: <Widget>[
        TextButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.black54),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        _loading
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Loader(
                  spinnerColor: Colors.black54,
                  color: Theme.of(context).primaryColorLight,
                  size: 24.0,
                ),
              )
            : TextButton(
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.black54),
                ),
                onPressed: () async {
                  Fluttertoast.showToast(msg: 'deleted');
                  Navigator.pop(context);
                },
              ),
      ],
    );
  }
}
