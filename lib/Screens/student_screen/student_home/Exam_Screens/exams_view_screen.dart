import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../shared/components/constants.dart';
import '../../../../shared/components/loadingWidget.dart';
import 'questions_view_screen.dart';

class StudentExamView extends StatefulWidget {
  final StudentModel studentModel;
  final String className;

  const StudentExamView(
      {Key key, @required this.className, @required this.studentModel})
      : super(key: key);
  @override
  _StudentExamViewState createState() => _StudentExamViewState();
}

class _StudentExamViewState extends State<StudentExamView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          // iconTheme: IconThemeData(
          //   color: Colors.black54, //change your color here
          // ),
          // backgroundColor: Theme.of(context).primaryColorLight,
          title: HeadingText(
              alignment: Alignment.topLeft,
              text: 'Exams',
              color: Theme.of(context).primaryTextTheme.bodyText1.color),
        ),
        // backgroundColor: HexColor(appPrimaryColour),
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
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
                    text: 'No Exams yet',
                    size: 17.0,
                    color: Theme.of(context).primaryTextTheme.bodyText1.color);
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

              // for (int i = 0; i < snapshot.data.docs.length; ++i) {
              //   DocumentSnapshot documentSnapshot = snapshot.data.docs[i];
              //   decoratedContainer.add(
              //     DecoratedContainer(
              //       child: Column(
              //         children: [
              //           HeadingText(
              //             text: documentSnapshot.data()['ExamName'] ?? '---',
              //             size: 17.0,
              //             color:Theme.of(context).primaryTextTheme.bodyText1.color
              //           ),
              //         ],
              //       ),
              //       onpressed: () {
              //         Navigator.of(context, rootNavigator: true)
              //             .push(MaterialPageRoute(builder: (context) {
              //           return StudentQuestionsViewScreen(
              //               documentSnapshot: widget.documentSnapshot,
              //               className: widget.className,
              //               examID: documentSnapshot.id);
              //         }));
              //       },
              //     ),
              //   );
              // }
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return DecoratedCard(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(builder: (context) {
                        return StudentQuestionsViewScreen(
                            totalMarks: snapshot.data.docs[index]['TotalMarks'],
                            examName: snapshot.data.docs[index]['ExamName'],
                            studentModel: widget.studentModel,
                            className: widget.className,
                            examID: snapshot.data.docs[index].id);
                      }));
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            HeadingText(
                                // alignment: Alignment.centerRight,
                                text: 'From' +
                                    ' ' +
                                    snapshot.data.docs[index]['From'],
                                size: 15.0,
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText1
                                    .color),
                            SizedBox(
                              width: 20.0,
                            ),
                            HeadingText(
                                // alignment: Alignment.centerRight,
                                text: 'To' +
                                    ' ' +
                                    snapshot.data.docs[index]['To'],
                                size: 15.0,
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText1
                                    .color),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        HeadingText(
                            alignment: Alignment.centerLeft,
                            text: 'Total Marks ' +
                                snapshot.data.docs[index]['TotalMarks'],
                            size: 15.0,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .bodyText1
                                .color),

                        // GetMarks(
                        //     examName: snapshot.data.docs[index]['ExamName'],
                        //     studentModel: widget.studentModel,
                        //     className: widget.className,
                        //     examID: snapshot.data.docs[index].id),
                        SizedBox(
                          height: 10.0,
                        ),
                        HeadingText(
                            alignment: Alignment.centerLeft,
                            text: snapshot.data.docs[index]['ExamName'],
                            size: 17.0,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .bodyText1
                                .color),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          width: size.width * 0.6,
                          height: 1.0,
                          color: Colors.black,
                        ),
                        HeadingText(
                            alignment: Alignment.centerLeft,
                            text: 'Important Notes',
                            size: 13.0,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .bodyText1
                                .color),
                        SizedBox(
                          height: 5.0,
                        ),
                        HeadingText(
                          alignment: Alignment.centerLeft,
                          text: snapshot.data.docs[index]['Notes'] ?? '--',
                          size: 17.0,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .bodyText1
                              .color,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ));
  }

  StreamBuilder<DocumentSnapshot> buildSubmittedAnswer(
      DocumentSnapshot documentSnapshot, String examID) {
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
            .doc(examID)
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
                  color: Theme.of(context).primaryTextTheme.bodyText1.color),
              SizedBox(
                height: 10.0,
              ),
              HeadingText(
                  alignment: Alignment.centerLeft,
                  text: 'Marks' + ' ' + snapshot.data.data()['Marks'] ?? '---',
                  size: 15.0,
                  color: Theme.of(context).primaryTextTheme.bodyText1.color),
            ],
          );
        });
  }
}

// class GetMarks extends StatefulWidget {
//   final String className;
//   final String examID;
//   final StudentModel studentModel;
//   final String examName;

//   const GetMarks({
//     Key key,
//     @required this.className,
//     @required this.examID,
//     @required this.studentModel,
//     @required this.examName,
//   }) : super(key: key);

//   @override
//   _GetMarksState createState() => _GetMarksState();
// }

// class _GetMarksState extends State<GetMarks> {
//   Future _getMarks() async {}
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       builder: (context, snapshot) {},
//     );
//   }
// }
