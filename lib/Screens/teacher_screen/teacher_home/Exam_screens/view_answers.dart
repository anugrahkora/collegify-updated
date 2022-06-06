import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/Screens/teacher_screen/teacher_home/Exam_screens/openAssignMarksPopup.dart';
import 'package:collegify/models/user_model.dart';
import 'package:collegify/shared/components/constants.dart';
import 'package:collegify/shared/components/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ViewAnswersScreen extends StatefulWidget {
  final TeacherModel teacherModel;
  final String className;
  final String semester;
  final String courseName;
  final String examID;
  final String questionID;
  final String marks;

  const ViewAnswersScreen(
      {Key key,
      @required this.teacherModel,
      @required this.className,
      @required this.semester,
      @required this.courseName,
      @required this.examID,
      @required this.questionID,
      @required this.marks})
      : super(key: key);
  @override
  _ViewAnswersScreenState createState() => _ViewAnswersScreenState();
}

class _ViewAnswersScreenState extends State<ViewAnswersScreen> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black54, //change your color here
        ),
        title: HeadingText(
          alignment: Alignment.centerLeft,
          text: 'Answers',
          size: 17.0,
          color:Theme.of(context).primaryTextTheme.bodyText1.color,
        ),
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
      // backgroundColor: HexColor(appPrimaryColour),
      body: StreamBuilder(
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
            .doc(widget.questionID)
            .collection('Answer')
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
              text: 'No Answers yet',
              size: 17.0,
              color:Theme.of(context).primaryTextTheme.bodyText1.color,
            );
          }
          List<DecoratedCard> decoratedContainer = [];
          for (int i = 0; i < snapshot.data.docs.length; ++i) {
            DocumentSnapshot questionDocumentSnapshot = snapshot.data.docs[i];
            decoratedContainer.add(
              DecoratedCard(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HeadingText(
                          // fontWeight: FontWeight.bold,
                          text:
                              questionDocumentSnapshot.data()['Name'] ?? '---',
                          size: 17.0,
                          color:Theme.of(context).primaryTextTheme.bodyText1.color,
                        ),
                        HeadingText(
                          fontWeight: FontWeight.w500,
                          text: questionDocumentSnapshot
                                  .data()['Date']
                                  .toString()
                                  .substring(0, 16) ??
                              '---',
                          size: 13.0,
                          color:Theme.of(context).primaryTextTheme.bodyText1.color,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HeadingText(
                          alignment: Alignment.centerLeft,
                          // fontWeight: FontWeight.w500,
                          text: questionDocumentSnapshot.id,
                          size: 15.0,
                          color:Theme.of(context).primaryTextTheme.bodyText1.color,
                        ),
                        HeadingText(
                          alignment: Alignment.centerRight,
                          text: 'Marks' + ' ' + widget.marks,
                          size: 15.0,
                          color:Theme.of(context).primaryTextTheme.bodyText1.color,
                        ),
                      ],
                    ),
                    Container(
                      width: size.width * 0.7,
                      height: 0.5,
                      color:Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                    Container(
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 15.0),
                        child: HeadingText(
                          alignment: Alignment.centerLeft,
                          text: questionDocumentSnapshot.data()['Answer'] ??
                              '---',
                          size: 15.0,
                          color:Theme.of(context).primaryTextTheme.bodyText1.color,
                        ),
                      ),
                    ),
                    buildStreamBuilder(questionDocumentSnapshot),
                  ],
                ),
                onTap: () {},
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
    );
  }

  StreamBuilder<DocumentSnapshot> buildStreamBuilder(
      DocumentSnapshot questionDocumentSnapshot) {
    return StreamBuilder(
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
          .doc(widget.questionID)
          .collection('Answer')
          .doc(questionDocumentSnapshot.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader(
            size: 20.0,
            spinnerColor: Colors.black54,
          );
        }
        if (snapshot.data['Marks'] == null) {
          return HeadingText(
            text: 'Unknown error',
            size: 20,
            color:Theme.of(context).primaryTextTheme.bodyText1.color,
          );
        }
        if (snapshot.data['Marks'] == 'Not assigned') {
          return RoundedButton(
            text: 'Assign',
            loading: _loading,
           color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return OpenAssignMarksPopup(
                      teacherModel: widget.teacherModel,
                      className: widget.className,
                      courseName: widget.courseName,
                      questionID: widget.questionID,
                      examID: widget.examID,
                      semester: widget.semester,
                      questionDocumentSnapshot: questionDocumentSnapshot,
                      maximumMark: widget.marks,
                    );
                  });
            },
          );
        }
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeadingText(
                  textAlign: TextAlign.right,
                  // alignment: Alignment.centerRight,
                  text: 'Assigned mark',

                  size: 15.0,
                  color:Theme.of(context).primaryTextTheme.bodyText1.color,
                ),
                HeadingText(
                  textAlign: TextAlign.right,
                  // alignment: Alignment.centerRight,
                  text: snapshot.data['Marks'],
                  size: 15.0,
                  color:Theme.of(context).primaryTextTheme.bodyText1.color,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
