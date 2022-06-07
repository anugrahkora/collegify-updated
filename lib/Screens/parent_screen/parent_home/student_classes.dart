import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/models/user_model.dart';
import 'package:flutter/material.dart';
import '../../../authentication/auth_service.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/components/darkmode_switch.dart';
import '../../../shared/components/loadingWidget.dart';
import 'ward_attendance.dart';

class StudentAttendanceStatus extends StatefulWidget {
  final ParentModel parentModel;
  final StudentModel wardModel;

  const StudentAttendanceStatus({
    Key key,
    @required this.parentModel,
    @required this.wardModel,
  }) : super(key: key);
  @override
  _StudentAttendanceStatusState createState() =>
      _StudentAttendanceStatusState();
}

class _StudentAttendanceStatusState extends State<StudentAttendanceStatus> {
  List<String> teacherNames = [];
  StudentModel wardModel;

  final AuthService _authService = new AuthService();
  // Future _getWardData() async {
  //   DocumentSnapshot doc;
  //   try {
  //     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  //     await firebaseFirestore
  //         .collection('users')
  //         .where('Registration_Number', isEqualTo: widget.parentModel.regNumber)
  //         .where('Role', isEqualTo: 'student')
  //         .get()
  //         .then(
  //       (value) {
  //         value.docs.forEach((element) {
  //           doc = element;
  //           setState(() {
  //             wardModel = StudentModel(
  //                 name: element.data()['Name'],
  //                 department: element.data()['Department'],
  //                 course: element.data()['Course'],
  //                 semester: element.data()['Semester'],
  //                 regNumber: element.data()['Registration_Number']);
  //           });
  //         });
  //       },
  //     );
  //     return doc;
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: Drawer(
          backgroundColor: Theme.of(context).primaryColor,
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ImageIcon(
                    AssetImage('assets/icons/iconParentLarge.png'),
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .selectedItemColor,
                    size: 20,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  color: Theme.of(context).primaryColorLight,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        HeadingText(
                          alignment: Alignment.centerLeft,
                          text: widget.parentModel.name ?? '...',
                          color: Theme.of(context)
                              .primaryTextTheme
                              .bodyText1
                              .color,
                          size: 15.0,
                        ),
                        HeadingText(
                          alignment: Alignment.centerLeft,
                          text: widget.parentModel.regNumber ?? '...',
                          color: Theme.of(context)
                              .primaryTextTheme
                              .bodyText1
                              .color,
                          size: 15.0,
                        ),
                        HeadingText(
                          alignment: Alignment.centerLeft,
                          text: widget.wardModel.department
                                  .replaceAll('_', " ") ??
                              '...',
                          color: Theme.of(context)
                              .primaryTextTheme
                              .bodyText1
                              .color,
                          size: 15.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: size.height * 0.25,
              // ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: HeadingText(
                  alignment: Alignment.centerLeft,
                  color: Theme.of(context).primaryTextTheme.bodyText1.color,
                  text: 'Announcements from College',
                  size: 15,
                ),
              ),
              SizedBox(
                width: size.width,
                height: size.height * 0.2,
                child: Container(child: buildStreamBuilder()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: ListTile(
                  tileColor: Theme.of(context).primaryColorLight,
                  // selectedTileColor: HexColor(appSecondaryColour),
                  trailing: darkModeSwitch(context),
                  title: HeadingText(
                    alignment: Alignment.center,
                    text: 'Darkmode',
                    color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    size: 14.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: ListTile(
                  tileColor: Theme.of(context).colorScheme.secondary,
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
                  onTap: () async {
                    // showAlertDialog(context);
                    await _authService.signOut();
                  },
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 15.0),
            child: ImageIcon(
              AssetImage('assets/icons/iconTeacher.png'),
              color:
                  Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            ),
          ),
        ),
        // backgroundColor: HexColor(appPrimaryColour),
        body: SafeArea(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(college)
                  .doc(widget.wardModel.department)
                  .collection('CourseNames')
                  .doc(widget.wardModel.course)
                  .collection('Semester')
                  .doc(widget.wardModel.semester)
                  .collection('Classes')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Loader(
                    size: 20.0,
                    spinnerColor: Colors.black54,
                    color: Theme.of(context).primaryColor,
                  );
                }
                if (snapshot.data.docs.length == 0) {
                  return HeadingText(
                    // fontWeight: FontWeight.w500,
                    text: 'No Classes yet',
                    size: 17.0,
                    color: Theme.of(context).primaryTextTheme.bodyText1.color,
                  );
                }
                List<DecoratedCard> decoratedContainer = [];
                for (int i = 0; i < snapshot.data.docs.length; ++i) {
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[i];
                  decoratedContainer.add(
                    DecoratedCard(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HeadingText(
                            alignment: Alignment.centerLeft,
                            text:
                                documentSnapshot.data()['ClassesName'] ?? '---',
                            size: 17.0,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .bodyText1
                                .color,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          HeadingText(
                            alignment: Alignment.centerLeft,
                            text:
                                documentSnapshot.data()['TeacherName'] ?? '---',
                            size: 15.0,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .bodyText1
                                .color,
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => WardAttendanceStatus(
                                className:
                                    documentSnapshot.data()['ClassesName'],
                                wardModel: widget.wardModel),
                          ),
                        );
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
              }),
        ));
  }

  StreamBuilder<QuerySnapshot> buildStreamBuilder() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(college)
          .doc('announcement')
          .collection('adminAnnouncement')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return HeadingText(
            color: Colors.black87,
            text: 'Unknown error',
            size: 17,
          );
        } else if (snapshot.hasData) {
          if (snapshot.data.docs.length == 0) {
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
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText1
                                  .color,
                              text: snapshot.data.docs[index]['Title'],
                              size: 15,
                            ),
                            HeadingText(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText1
                                  .color,
                              text: snapshot.data.docs[index]['Date'],
                              size: 13,
                            ),
                          ],
                        ),
                        HeadingText(
                          alignment: Alignment.topLeft,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .bodyText1
                              .color,
                          text: snapshot.data.docs[index]['Body'],
                          size: 13,
                        ),
                      ],
                    ),
                  );
                });
        }

        return Loader(
          color: Theme.of(context).primaryColor,
          size: 20.0,
          spinnerColor: Theme.of(context).primaryTextTheme.bodyText1.color,
        );
      },
    );
  }

  ListView buildListView(Size size) {
    return ListView.builder(
      // scrollDirection: Axis.horizontal,
      itemCount: teacherNames.length,
      itemBuilder: (BuildContext context, index) {
        return Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              width: size.width * 0.8,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      offset: Offset(6, 2),
                      blurRadius: 6.0,
                      spreadRadius: 0.0),
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      offset: Offset(-6, -2),
                      blurRadius: 6.0,
                      spreadRadius: 0.0),
                ],
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                child: HeadingText(
                  color: Colors.black87,
                  text: teacherNames[index],
                  size: 23,
                ),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ()
                  //   ),
                  // );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
