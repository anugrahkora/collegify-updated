import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../../../database/databaseService.dart';
import '../../../../models/user_model.dart';
import '../../../../shared/components/constants.dart';
import '../../../../shared/components/loadingWidget.dart';
import 'view_notes.dart';

class CreateModuleScreen extends StatefulWidget {
  final TeacherModel teacherModel;
  final String className;
  final String semester;
  final String courseName;

  const CreateModuleScreen({
    Key key,
    @required this.teacherModel,
    @required this.className,
    @required this.semester,
    @required this.courseName,
  }) : super(key: key);
  @override
  _CreateModuleScreenState createState() => _CreateModuleScreenState();
}

class _CreateModuleScreenState extends State<CreateModuleScreen> {
  List<QueryDocumentSnapshot> moduleList = [];

  List<Image> imageList = [];
  FullMetadata fullMetadata;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    // Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: HeadingText(
          text: '${widget.className}',
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
        ),
      ),
      // backgroundColor: HexColor(appPrimaryColour),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(college)
                .doc(widget.teacherModel.department)
                .collection('CourseNames')
                .doc(widget.courseName)
                .collection('Semester')
                .doc(widget.semester)
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
                                fontWeight: FontWeight.w500,
                                alignment: Alignment.topLeft,
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText1
                                    .color,
                                text:
                                    documentSnapshot.data()['Module'] ?? '---',
                                size: 17,
                              ),
                            ),
                            PopupMenuButton(
                              enableFeedback: true,
                              child: Center(
                                  child: Icon(
                                Icons.more_vert,
                                color: Theme.of(context)
                                    .bottomNavigationBarTheme
                                    .selectedItemColor,
                              )),
                              itemBuilder: (context) {
                                return List.generate(1, (i) {
                                  return PopupMenuItem(
                                    child: TextButton(
                                        child: HeadingText(
                                          // fontWeight: FontWeight.w500,
                                          alignment: Alignment.topLeft,
                                          color: Colors.black54,
                                          text: 'Delete',
                                          size: 15,
                                        ),
                                        onPressed: () async {
                                          try {
                                            dynamic result =
                                                await DatabaseService()
                                                    .deleteModule(
                                                        widget.teacherModel
                                                            .department,
                                                        widget.courseName,
                                                        widget.semester,
                                                        widget.className,
                                                        documentSnapshot
                                                            .data()['Module']);

                                            if (result != null)
                                              throw Fluttertoast.showToast(
                                                  msg: 'Error');
                                          } on FirebaseException catch (e) {
                                            Fluttertoast.showToast(
                                                msg: e.message);
                                          }
                                        }),
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                        HeadingText(
                          alignment: Alignment.centerLeft,
                          // fontWeight: FontWeight.w300,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .bodyText1
                              .color,
                          text: documentSnapshot.data()['Description'],
                          size: 15,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => ViewNotesScreen(
                              teacherModel: widget.teacherModel,
                              className: widget.className,
                              semester: widget.semester,
                              courseName: widget.courseName,
                              moduleName: documentSnapshot.data()['Module']),
                        ),
                      );
                    },
                  ),
                );
              }
              return Center(
                child: Column(
                  children: decoratedContainer,
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: HeadingText(
          text: 'Add Module',
          size: 13.0,
          color: Colors.white,
        ),
        heroTag: 'buttonAddModules',
        // splashColor: HexColor('#99b4bf'),
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
                    uid: user.uid,
                    className: widget.className,
                    courseName: widget.courseName,
                    semester: widget.semester,
                    path:
                        'Notes/${widget.teacherModel.department}/${widget.courseName}/${widget.semester}/${widget.className}',
                    teacherModel: widget.teacherModel,
                  );
                });
          } catch (e) {
            Fluttertoast.showToast(msg: e.toString());
          }
        },
        icon: Icon(Icons.add),
      ),
    );
  }
}

class OpenPopupDialogue extends StatefulWidget {
  final String uid;
  final String path;
  final String className;
  final String courseName;
  final String semester;
  final TeacherModel teacherModel;

  const OpenPopupDialogue(
      {Key key,
      @required this.path,
      @required this.teacherModel,
      @required this.className,
      @required this.uid,
      @required this.courseName,
      @required this.semester})
      : super(key: key);
  @override
  _OpenPopupDialogueState createState() => _OpenPopupDialogueState();
}

class _OpenPopupDialogueState extends State<OpenPopupDialogue> {
  DatabaseService _databaseService = new DatabaseService();
  String _moduleName;
  String _description;
  bool _loading = false;
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: HeadingText(
        text: 'Add Module',
        size: 17.0,
        color: Theme.of(context).primaryTextTheme.bodyText1.color,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: Form(
        key: _formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RoundedInputField(
              hintText: 'Module Name',
              validator: (val) => val.isEmpty ? 'Field Mandatory' : null,
              onChanged: (val) {
                _moduleName = val;
              },
            ),
            RoundedInputField(
              hintText: 'Description',
              validator: (val) => val.isEmpty ? 'Field Mandatory' : null,
              onChanged: (val) {
                _description = val;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        _loading
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Loader(
                  spinnerColor: Colors.black54,
                  color: Theme.of(context).primaryColor,
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
                      _moduleName.isNotEmpty) {
                    setState(() {
                      _loading = !_loading;
                    });
                    try {
                      dynamic docExists =
                          await _databaseService.checkIfModuleExists(
                        widget.teacherModel.department,
                        widget.courseName,
                        widget.semester,
                        widget.className,
                        _moduleName,
                      );
                      if (!docExists) {
                        dynamic result = await _databaseService.addModule(
                            widget.teacherModel.department,
                            widget.courseName,
                            widget.semester,
                            widget.className,
                            _moduleName,
                            _description);
                        if (result != null) {
                          Fluttertoast.showToast(msg: 'Failed');
                        } else {
                          Fluttertoast.showToast(msg: 'Added');
                        }
                      } else
                        Fluttertoast.showToast(
                            msg: 'Module already exists, enter another name');
                      Navigator.of(context, rootNavigator: true).pop();
                    } catch (e) {
                      Fluttertoast.showToast(msg: 'Error');
                    }
                  }
                })
      ],
    );
  }
}
