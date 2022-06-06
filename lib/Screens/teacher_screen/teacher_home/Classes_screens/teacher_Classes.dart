import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../../../authentication/auth_service.dart';
import '../../../../database/databaseService.dart';
import '../../../../models/user_model.dart';
import '../../../../shared/components/constants.dart';
import '../../../../shared/components/dropDownList.dart';
import '../../../../shared/components/loadingWidget.dart';
import '../Teacher_Navigation.dart';

class TeacherHome extends StatefulWidget {
  final TeacherModel teacherModel;
  final String semester;

  const TeacherHome({Key key, @required this.teacherModel, this.semester})
      : super(key: key);
  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

@override
class _TeacherHomeState extends State<TeacherHome> {
  bool loading = false;
  List<QueryDocumentSnapshot> classList = [];
  DocumentSnapshot snapshot;

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Classes',
          style: GoogleFonts.poppins(
              color: Theme.of(context).primaryTextTheme.bodyText1.color, fontSize: 17.0),
        ),
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ImageIcon(
                  AssetImage('assets/icons/iconTeacherLarge.png'),
                  color: Colors.black54,
                  size: 10.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildDrawerWidgets(user),
            ),
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
              height: size.height * 0.3,
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
                  size: 14.0,
                ),
                onTap: () {
                  showSignOutAlertDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addNewClass',
        splashColor: HexColor('#99b4bf'),
        hoverElevation: 20,
        elevation: 3.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
        onPressed: () async {
          try {
            showDialog(
                context: context,
                builder: (_) {
                  return OpenPopupDialogue(
                    teacherModel: widget.teacherModel,
                    uid: user.uid,
                  );
                });
          } catch (e) {
            Fluttertoast.showToast(msg: e.message);
          }
        },
        child: Icon(Icons.add),
      ),
      // backgroundColor: HexColor(appPrimaryColour),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('Classes')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Loader(
                  color: Theme.of(context).primaryColor,
                  size: 30.0,
                  spinnerColor: Colors.black54);
            if (snapshot.hasError) {
              return HeadingText(
                text: 'Unknown error occured',
                size: 17.0,
                color: Theme.of(context).primaryTextTheme.bodyText1.color,
              );
            } else if (snapshot.data.docs.length == 0) {
              return HeadingText(
                text: 'No classes have been added',
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
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: HeadingText(
                              fontWeight: FontWeight.w400,
                              alignment: Alignment.topLeft,
                              color: Theme.of(context).primaryTextTheme.bodyText1.color,
                              text: documentSnapshot
                                      .data()['Course']
                                      .replaceAll('_', ' ') ??
                                  '---',
                              size: 17,
                            ),
                          ),
                          PopupMenuButton(
                            enableFeedback: true,
                            child: Center(
                                child: Icon(
                              Icons.more_vert,
                              color: Theme.of(context).colorScheme.secondary,
                            )),
                            itemBuilder: (context) {
                              return List.generate(1, (i) {
                                return PopupMenuItem(
                                  child: TextButton(
                                    child: HeadingText(
                                      // fontWeight: FontWeight.w500,
                                      alignment: Alignment.topLeft,
                                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                                      text: 'Delete',
                                      size: 15,
                                    ),
                                    onPressed: () async {
                                      dynamic result =
                                          await DatabaseService(uid: user.uid)
                                              .removeAddedClass(
                                        widget.teacherModel.department,
                                        documentSnapshot.data()['Course'],
                                        documentSnapshot.data()['ClassName'],
                                        documentSnapshot.data()['Semester'],
                                        widget.teacherModel.name,
                                      );
                                      if (result != null)
                                        Fluttertoast.showToast(
                                            msg: result.toString());
                                      else {
                                        Fluttertoast.showToast(msg: 'Removed');
                                      }
                                    },
                                  ),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HeadingText(
                            fontWeight: FontWeight.w300,
                            alignment: Alignment.topLeft,
                            color: Theme.of(context).primaryTextTheme.bodyText1.color,
                            text: documentSnapshot
                                    .data()['ClassName']
                                    .replaceAll('_', ' ') ??
                                '---',
                            size: 15,
                          ),
                          SizedBox(
                            width: 25.0,
                          ),
                          HeadingText(
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context).primaryTextTheme.bodyText1.color,
                            text: 's ' + documentSnapshot.data()['Semester'],
                            size: 15,
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeacherNavigationScreen(
                          teacherModel: widget.teacherModel,
                          className: documentSnapshot.data()['ClassName'],
                          semester: documentSnapshot.data()['Semester'],
                          courseName: documentSnapshot.data()['Course'],
                          // documentSnapshot: widget.documentSnapshot,
                        ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: decoratedContainer,
                ),
              ),
            );
          },
        ),
      ),
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
          print(snapshot.data);
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
                          text: snapshot.data.docs[index]['Title'] ?? '---',
                          size: 15,
                        ),
                        HeadingText(
                          color: Theme.of(context).primaryTextTheme.bodyText1.color,
                          text: snapshot.data.docs[index]['Date'] ?? '---',
                          size: 13,
                        ),
                      ],
                    ),
                    HeadingText(
                      alignment: Alignment.topLeft,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                      text: snapshot.data.docs[index]['Body'] ?? '---',
                      size: 13,
                    ),
                  ],
                ),
              );
            });
      },
    );
  }

  Widget buildDrawerWidgets(UserModel user) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          child: Column(
            children: [
              HeadingText(
                alignment: Alignment.centerLeft,
                text: widget.teacherModel.name ?? '...',
                color: Colors.black54,
                size: 17.0,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: HeadingText(
                    alignment: Alignment.centerLeft,
                    text: user.email,
                    size: 15.0,
                    color: Colors.black54,
                  ),
                ),
              ),
              HeadingText(
                alignment: Alignment.centerLeft,
                text: widget.teacherModel.department.replaceAll('_', ' ') ??
                    '...',
                color: Colors.black54,
                size: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  showSignOutAlertDialog(BuildContext buildcontext) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.pop(buildcontext);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Continue",
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () async {
        await _authService.signOut();
        Navigator.pop(context);
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

// set up the AlertDialog

class OpenPopupDialogue extends StatefulWidget {
  final String uid;
  final TeacherModel teacherModel;

  const OpenPopupDialogue({Key key, this.uid, @required this.teacherModel})
      : super(key: key);
  @override
  _OpenPopupDialogueState createState() => _OpenPopupDialogueState();
}

class _OpenPopupDialogueState extends State<OpenPopupDialogue> {
  String _className;
  String _courseName;
  String _selectedSemester;
  bool _loading = false;
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: HeadingText(
        text: 'Add Class',
        size: 17.0,
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
                DropDownListForCourseNames(
                  departmentName: widget.teacherModel.department,
                  selectedCourseName: _courseName,
                  onpressed: (val) {
                    setState(() {
                      _courseName = val;
                      _selectedSemester = null;
                    });
                  },
                ),
                DropDownListForYearData(
                    departmentName: widget.teacherModel.department,
                    courseName: _courseName,
                    selectedYear: _selectedSemester,
                    onpressed: (val) {
                      setState(() {
                        _selectedSemester = val;
                      });
                    }),
                RoundedInputField(
                  hintText: 'New class name',
                  validator: (val) => val.isEmpty ? 'Field Mandatory' : null,
                  onChanged: (val) {
                    _className = val;
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
                  if (_formkey.currentState.validate() &&
                      _courseName != null &&
                      _selectedSemester != null) {
                    setState(() {
                      _loading = true;
                    });
                    try {
                      dynamic docExists = await DatabaseService()
                          .checkIfClassDocExists(widget.uid, _className);
                      if (!docExists) {
                        await DatabaseService(uid: widget.uid).assignClassNames(
                            _courseName, _className, _selectedSemester);
                        await DatabaseService(uid: widget.uid).addNewClass(
                          widget.teacherModel.department,
                          _courseName,
                          _className,
                          _selectedSemester,
                          widget.teacherModel.name,
                        );
                        setState(() {
                          _loading = false;
                        });

                        Navigator.of(context).pop();
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Class Name already exists');
                        setState(() {
                          _loading = false;
                        });
                        Navigator.of(context).pop();
                      }
                    } on FirebaseException catch (e) {
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  }
                })
      ],
    );
  }
}
