import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../models/user_model.dart';
import '../../../../shared/components/constants.dart';
import 'view_parent_announcement.dart';
import 'view_student_announcement.dart';

class TeacherAnnouncementScreen extends StatefulWidget {
  final TeacherModel teacherModel;
  final String semester;
  final String courseName;
  final String className;

  const TeacherAnnouncementScreen(
      {Key key,
      @required this.teacherModel,
      @required this.semester,
      @required this.courseName,
      @required this.className})
      : super(key: key);
  @override
  _TeacherAnnouncementScreenState createState() =>
      _TeacherAnnouncementScreenState();
}

class _TeacherAnnouncementScreenState extends State<TeacherAnnouncementScreen> {
  bool loading = false;
  List<AnnouncementModel> studentAnnouncements = [];
  List<AnnouncementModel> parentAnnouncements = [];
  DocumentSnapshot snapshot;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  List<Widget> _buildScreens() {
    return [
      ViewStudentAnnouncements(
        className: widget.className,
        courseName: widget.courseName,
        teacherModel: widget.teacherModel,
        semester: widget.semester,
      ),
      ViewParentAnnouncement(
        className: widget.className,
        courseName: widget.courseName,
        teacherModel: widget.teacherModel,
        semester: widget.semester,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: HeadingText(
            alignment: Alignment.topLeft,
            text: 'Announcements',
            color: Theme.of(context).primaryTextTheme.bodyText1.color,
            size: 17.0,
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: HeadingText(
                  text: 'Student',
                  color: Theme.of(context).primaryTextTheme.bodyText1.color,
                  size: 15.0,
                ),
                icon: ImageIcon(
                  AssetImage('assets/icons/iconStudent.png'),
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor,
                ),
              ),
              Tab(
                child: HeadingText(
                  text: 'Parent',
                  color: Theme.of(context).primaryTextTheme.bodyText1.color,
                  size: 15.0,
                ),
                icon: ImageIcon(
                  AssetImage('assets/icons/iconParent.png'),
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor,
                ),
              ),
            ],
          ),
        ),
        // backgroundColor: HexColor(appPrimaryColour),
        body: SafeArea(
            // child: SingleChildScrollView(
            child: TabBarView(
          children: _buildScreens(),
        )),
      ),
    );
  }
}
