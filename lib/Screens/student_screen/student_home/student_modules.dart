import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/components/loadingWidget.dart';
import 'student_notes.dart';

class StudentModulesScreen extends StatefulWidget {
  final String className;
  final String courseName;
  final StudentModel studentModel;

  const StudentModulesScreen(
      {Key key,
      @required this.className,
      @required this.courseName,
      @required this.studentModel})
      : super(key: key);
  @override
  _StudentModulesScreenState createState() => _StudentModulesScreenState();
}

class _StudentModulesScreenState extends State<StudentModulesScreen> {
  ListResult moduleList;

  // Future<int> _getModules() async {
  //   _filePath =
  //       '${widget.documentSnapshot.data()['University']}/${widget.documentSnapshot.data()['College']}/Notes/${widget.documentSnapshot.data()['Department']}/${widget.documentSnapshot.data()['Course']}/${widget.documentSnapshot.data()['Semester']}/${widget.className}';
  //   final _storage = FirebaseStorage.instance.ref().child(_filePath);
  //   moduleList = await _storage.listAll();
  //   return moduleList.prefixes.length;
  // }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: HeadingText(
          alignment: Alignment.topLeft,
          text: widget.className,
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
          size: 17.0,
        ),
      ),
      // backgroundColor: HexColor(appPrimaryColour),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('myCollege')
              .doc(widget.studentModel.department)
              .collection('CourseNames')
              .doc(widget.courseName)
              .collection('Semester')
              .doc(widget.studentModel.semester)
              .collection('Classes')
              .doc(widget.className)
              .collection('Modules')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loader(
                  color: Theme.of(context).primaryColor,
                  size: 34.0,
                  spinnerColor: Colors.black54);
            }
            if (snapshot.data.docs.length == 0) {
              return HeadingText(
                text: 'No Modules have been added',
                size: 15.0,
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
              );
            } else if (snapshot.hasError) {
              return HeadingText(
                text: 'Unknown error occured',
                size: 24.0,
                color: Colors.black87,
              );
            }

            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, index) {
                  return DecoratedCard(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => StudentNotes(
                              studentModel: widget.studentModel,
                              // documentSnapshot: widget.documentSnapshot,
                              className: widget.className,
                              courseName: widget.courseName,
                              moduleName: snapshot.data.docs[index]['Module']),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        HeadingText(
                          // fontWeight: FontWeight.w500,
                          alignment: Alignment.centerLeft,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .bodyText1
                              .color,
                          text: snapshot.data.docs[index]['Module'],
                          size: 17,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        HeadingText(
                          alignment: Alignment.centerLeft,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .bodyText1
                              .color,
                          text: snapshot.data.docs[index]['Description'],
                          size: 15,
                        ),
                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  // ListView buildListView(Size size) {
  //   return ListView.builder(
  //       itemCount: moduleList.prefixes.length,
  //       itemBuilder: (BuildContext context, index) {
  //         return Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //           child: DecoratedContainer(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 HeadingText(
  //                   text: 'Module',
  //                   size: 17.0,
  //                   color: Theme.of(context).primaryTextTheme.bodyText1.color,
  //                 ),
  //                 HeadingText(
  //                   text: moduleList.prefixes[index].name,
  //                   size: 20.0,
  //                   color: Theme.of(context).primaryTextTheme.bodyText1.color,
  //                 ),
  //               ],
  //             ),
  //             onpressed: () {
  //               Navigator.of(context, rootNavigator: true).push(
  //                 MaterialPageRoute(
  //                   builder: (context) => StudentNotes(
  //                     className: widget.className,
  //                     documentSnapshot: widget.documentSnapshot,
  //                     courseName: widget.courseName,
  //                     moduleName: moduleList.prefixes[index].name,
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         );
  //       });
  // }
}
