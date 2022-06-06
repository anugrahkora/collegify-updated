import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../../authentication/auth_service.dart';
import '../../../models/user_model.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/components/loadingWidget.dart';
import 'announcements_screen/student_announcements.dart';
import 'student_navigation.dart';

class StudentClassList extends StatefulWidget {
  final StudentModel studentModel;

  const StudentClassList({Key key, @required this.studentModel})
      : super(key: key);
  @override
  _StudentClassListState createState() => _StudentClassListState();
}

class _StudentClassListState extends State<StudentClassList> {
  List<QueryDocumentSnapshot> classes = [];

  String name;

  String selectedTeacher;
  String teacherUid;
  String teacherClassName;
  final AuthService _authService = new AuthService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<UserModel>(context);

    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: [
                  ImageIcon(
                    AssetImage('assets/icons/iconStudentLarge.png'),
                    color: Colors.black54,
                    size: 90,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: HeadingText(
                        text: user.email,
                        size: 15.0,
                        color: Theme.of(context).primaryTextTheme.bodyText1.color,
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            buildPadding(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: HeadingText(
                alignment: Alignment.centerLeft,
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
                text: 'Announcements',
                size: 15,
              ),
            ),
            SizedBox(
              width: size.width,
              height: size.height * 0.4,
              child: Container(child: buildStreamBuilder()),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: ListTile(
                tileColor: Theme.of(context).colorScheme.secondary,
                // selectedTileColor: HexColor(appSecondaryColour),
                trailing: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: HeadingText(
                  alignment: Alignment.center,
                  text: 'Sign Out',
                  color: Colors.white,
                  size: 13.0,
                ),
                onTap: () {
                  showSignOutAlertDialog(context);
                  // await _authService.signOut();
                },
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black54, //change your color here
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColorLight,
        title: HeadingText(
          alignment: Alignment.topLeft,
          text: 'Classes',
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
          size: 17.0,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(
                        builder: (context) => StudentAnnouncements(
                              studentModel: widget.studentModel,
                            )));
              }),
        ],
      ),
      // backgroundColor: HexColor(appPrimaryColour),
      body: SafeArea(
          child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('myCollege')
            .doc(widget.studentModel.department)
            .collection('CourseNames')
            .doc(widget.studentModel.course)
            .collection('Semester')
            .doc(widget.studentModel.semester)
            .collection('Classes')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Loader(
              color: Theme.of(context).primaryColor,
              size: 30.0,
              spinnerColor: Theme.of(context).primaryTextTheme.bodyText1.color,
            );
          if (snapshot.hasError) {
            return HeadingText(
              color: Colors.black87,
              text: 'Unknown error',
              size: 17,
            );
          } else if (!snapshot.hasData) {
            return HeadingText(
              color: Theme.of(context).primaryTextTheme.bodyText1.color,
              text: 'No data',
              size: 17,
            );
          } else if (snapshot.data.docs.length == 0) {
            return HeadingText(
              color: Theme.of(context).primaryTextTheme.bodyText1.color,
              text: 'No classes have been added',
              size: 17,
            );
          } else
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, index) {
                return DecoratedCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return StudentNavigationScreen(
                          className: snapshot.data.docs[index].id,
                          courseName: widget.studentModel.course,
                          studentModel: widget.studentModel,
                        );
                      }),
                    );
                  },
                  child: Column(
                    children: [
                      HeadingText(
                        // fontWeight: FontWeight.w500,
                        alignment: Alignment.centerLeft,
                        color: Theme.of(context).primaryTextTheme.bodyText1.color,
                        text: snapshot.data.docs[index].id,
                        size: 17,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      HeadingText(
                        alignment: Alignment.centerLeft,
                        color: Theme.of(context).primaryTextTheme.bodyText1.color,
                        text: snapshot.data.docs[index]['TeacherName'],
                        size: 15,
                      ),
                    ],
                  ),
                );
              },
            );
        },
      )),
    );
  }

  StreamBuilder<QuerySnapshot> buildStreamBuilder() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('adminAnnouncement')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Loader(
            color: Theme.of(context).primaryColor,
            size: 20.0,
            spinnerColor: Theme.of(context).primaryTextTheme.bodyText1.color,
          );
        if (snapshot.hasError) {
          return HeadingText(
            color: Colors.black87,
            text: 'Unknown error',
            size: 17,
          );
        } else if (!snapshot.hasData) {
          return HeadingText(
            color: Theme.of(context).primaryTextTheme.bodyText1.color,
            text: 'No data',
            size: 17,
          );
        } else if (snapshot.data.docs.length == 0) {
          return HeadingText(
            color: Theme.of(context).primaryTextTheme.bodyText1.color,
            text: 'No admin Announcements',
            size: 17,
          );
        } else
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, index) {
                return DecoratedCard(
                  onTap: () {},
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HeadingText(
                            color: Theme.of(context).primaryTextTheme.bodyText1.color,
                            text: snapshot.data.docs[index]['Title'],
                            size: 15,
                          ),
                          HeadingText(
                            color: Theme.of(context).primaryTextTheme.bodyText1.color,
                            text: snapshot.data.docs[index]['Date'],
                            size: 13,
                          ),
                        ],
                      ),
                      HeadingText(
                        alignment: Alignment.topLeft,
                        color: Theme.of(context).primaryTextTheme.bodyText1.color,
                        text: snapshot.data.docs[index]['Body'],
                        size: 13,
                      ),
                    ],
                  ),
                );
              });
      },
    );
  }

  Padding buildPadding() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              HeadingText(
                alignment: Alignment.centerLeft,
                text: widget.studentModel.name,
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
                size: 15.0,
              ),
              HeadingText(
                alignment: Alignment.centerLeft,
                text: widget.studentModel.department
                        .toString()
                        .replaceAll('_', ' ') ??
                    '...',
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
                size: 13.0,
              ),
              HeadingText(
                alignment: Alignment.centerLeft,
                text: widget.studentModel.course
                        .toString()
                        .replaceAll('_', ' ') ??
                    '...',
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
                size: 13.0,
              ),
              HeadingText(
                alignment: Alignment.centerLeft,
                text: widget.studentModel.semester
                        .toString()
                        .replaceAll('_', ' ') ??
                    '...',
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
                size: 13.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ListView buildListView(Size size) {
  //   return ListView.builder(
  //     itemCount: classes.length ?? 0,
  //     itemBuilder: (BuildContext context, index) {
  //       return Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 15.0),
  //         child: DecoratedContainer(
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: HeadingText(
  //               color: Theme.of(context).primaryTextTheme.bodyText1.color,
  //               text: classes[index].id,
  //               size: 17,
  //             ),
  //           ),
  //           onpressed: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) {
  //                 return StudentNavigationScreen(
  //                   className: classes[index].id,
  //                   courseName: widget.documentSnapshot.data()['Course'],

  //                 );
  //               }

  //                   // StudentModulesScreen(
  //                   //   className: classes[index],
  //                   //   docs: widget.documentSnapshot,
  //                   //   courseName: widget.documentSnapshot.data()['Course'],
  //                   // ),
  //                   ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  showSignOutAlertDialog(BuildContext buildcontext) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Continue",
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () async {
        await _authService.signOut();
        Navigator.pop(buildcontext);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // backgroundColor: HexColor(appPrimaryColour),
      title: Text(
        "Sign out?",
        style: TextStyle(color: Colors.black),
      ),
      // content: Text(
      //     ""),
      actions: [
        cancelButton,
        continueButton,
      ],
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
