import 'package:collegify/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'Announcements_screens/teacher_announcement.dart';
import 'Attendance_screens/student_attendance_screen.dart';
import 'Attendance_screens/student_attendance_view_screen.dart';
import 'Classes_screens/create_module_screen.dart';
import 'Exam_screens/exam_view_scree.dart';

PersistentTabController _controller = PersistentTabController(initialIndex: 0);

class TeacherNavigationScreen extends StatefulWidget {
  final TeacherModel teacherModel;
  final String courseName;
  final String className;
  final String semester;

  const TeacherNavigationScreen({
    Key key,
    @required this.className,
    @required this.semester,
    @required this.courseName,
    @required this.teacherModel,
  }) : super(key: key);
  @override
  _TeacherNavigationScreenState createState() =>
      _TeacherNavigationScreenState();
}

class _TeacherNavigationScreenState extends State<TeacherNavigationScreen> {
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.book,
          color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        ),
        title: ("Notes"),
        activeColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        inactiveColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        activeContentColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.list_number,
          color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        ),
        title: ("Exams"),
        activeColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        inactiveColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        activeContentColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(
          AssetImage('assets/icons/iconStudent.png'),

          color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
          //  HexColor(appSecondaryColour),
        ),
        title: ("Students"),
        activeColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        inactiveColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        activeContentColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.graph_circle,
          color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        ),
        title: ("Attendance"),
        activeColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        inactiveColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        activeContentColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.bell,
          color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        ),
        title: ("Memo"),
        activeColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        inactiveColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        activeContentColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears.
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
      // decoration: NavBarDecoration(
      //   borderRadius: BorderRadius.circular(10.0),
      //   colorBehindNavBar: Colors.white,
      // ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style5, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      CreateModuleScreen(
        teacherModel: widget.teacherModel,
        className: widget.className,
        semester: widget.semester,
        courseName: widget.courseName,
      ),
      ExamViewScreen(
        teacherModel: widget.teacherModel,
        className: widget.className,
        courseName: widget.courseName,
        semester: widget.semester,
      ),
      StudentAttendance(
        teacherModel: widget.teacherModel,
        courseName: widget.courseName,
        className: widget.className,
        semester: widget.semester,
      ),
      StudentAttendanceViewScreen(
        teacherModel: widget.teacherModel,
        courseName: widget.courseName,
        className: widget.className,
        semester: widget.semester,
      ),
      // from student screen
      TeacherAnnouncementScreen(
        className: widget.className,
        courseName: widget.courseName,
        teacherModel: widget.teacherModel,
        semester: widget.semester,
      ),
    ];
  }
}
