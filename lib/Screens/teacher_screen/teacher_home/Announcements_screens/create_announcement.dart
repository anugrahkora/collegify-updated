import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/database/databaseService.dart';
import 'package:collegify/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../shared/components/constants.dart';

class CreateAnnouncement extends StatefulWidget {
  final String role;
  final TeacherModel teacherModel;
  final String semester;
  final Widget icon;
  final String courseName;
  final String className;

  const CreateAnnouncement({
    Key key,
    @required this.teacherModel,
    @required this.role,
    @required this.semester,
    @required this.icon,
    @required this.courseName,
    @required this.className,
  }) : super(key: key);
  @override
  _CreateAnnouncementParentState createState() =>
      _CreateAnnouncementParentState();
}

class _CreateAnnouncementParentState extends State<CreateAnnouncement> {
  String _title;
  String _body;

  bool _loading = false;
  final DatabaseService databaseService = new DatabaseService();
  final _formkey = GlobalKey<FormState>();
  DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black54),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 15.0),
          child: widget.icon,
        ),
      ),
      // backgroundColor: HexColor(appPrimaryColour),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0),
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  width: size.width * 0.8,
                  height: size.height * 0.6,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          offset: Offset(6, 2),
                          blurRadius: 6.0,
                          spreadRadius: 3.0),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (val) =>
                                val.isEmpty ? '* Mandatory' : null,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            onChanged: (val) {
                              setState(() {
                                _title = val;
                              });
                            },
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.montserrat(
                                  color: Colors.black54, fontSize: 16),
                              hintText: 'Subject',
                              border: InputBorder.none,
                            ),
                          ),
                          TextFormField(
                            validator: (val) =>
                                val.isEmpty ? '* Mandatory' : null,
                            keyboardType: TextInputType.multiline,
                            maxLines: 30,
                            onChanged: (val) {
                              setState(() {
                                _body = val;
                              });
                            },
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.montserrat(
                                  color: Colors.black54, fontSize: 16),
                              hintText: 'Body',
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                RoundedButton(
                  text: 'Post',
                  color: Theme.of(context).colorScheme.secondary,
                  loading: _loading,
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      try {
                        setState(() {
                          _loading = true;
                        });
                        if (widget.role == 'Student') {
                          dynamic result =
                              await databaseService.postStudentAnnouncement(
                            widget.teacherModel.department,
                            widget.courseName,
                            widget.semester,
                            widget.teacherModel.name,
                            dateTime.toString(),
                            _title,
                            _body,
                          );

                          if (result != null) {
                            Fluttertoast.showToast(msg: 'Failed');
                          } else
                            setState(() {
                              _loading = false;
                            });
                          Navigator.pop(context);
                        } else if (widget.role == 'Parent') {
                          dynamic result =
                              await databaseService.postParentAnnouncement(
                            widget.teacherModel.department,
                            widget.courseName,
                            widget.semester,
                            widget.teacherModel.name,
                            dateTime.toString(),
                            _title,
                            _body,
                          );
                          if (result != null) {
                            Fluttertoast.showToast(msg: 'Failed');
                          } else
                            setState(() {
                              _loading = false;
                            });
                          Navigator.pop(context);
                        }
                      } catch (e) {}
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
