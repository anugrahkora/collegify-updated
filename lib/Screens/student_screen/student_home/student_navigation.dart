import 'package:collegify/models/user_model.dart';
import 'Exam_Screens/exams_view_screen.dart';
import 'student_attendance.dart';
import 'student_modules.dart';
import '../../../shared/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';


PersistentTabController _controller = PersistentTabController(initialIndex: 0);

class StudentNavigationScreen extends StatefulWidget {
  
  final String className;
  final String courseName;
  final StudentModel studentModel;
  const StudentNavigationScreen(
      {Key key,
    
      @required this.className,
      @required this.courseName,@required this.studentModel})
      : super(key: key);
  @override
  _StudNavigationScreenState createState() => _StudNavigationScreenState();
}

class _StudNavigationScreenState extends State<StudentNavigationScreen> {
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.book,
          color: Colors.black,
        ),
        title: ("Notes"),
        activeColor: Colors.white,
        inactiveColor: CupertinoColors.systemGrey,
        activeContentColor: Theme.of(context).colorScheme.secondary,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.list_number,
          color: Colors.black,
        ),
        title: ("Exams"),
        activeColor: Colors.white,
        inactiveColor: CupertinoColors.systemGrey,
        activeContentColor: Theme.of(context).colorScheme.secondary,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.check_mark,
          color: Colors.black,
        ),
        title: ("Attendance"),
        activeColor: Colors.white,
        inactiveColor: CupertinoColors.systemGrey,
        activeContentColor: Theme.of(context).colorScheme.secondary,
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
          NavBarStyle.style13, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      StudentModulesScreen(
        studentModel: widget.studentModel,
        className: widget.className,
        courseName: widget.courseName,
       
      ),
      StudentExamView(
        studentModel: widget.studentModel,
       
        className: widget.className,
      ),
      StudentAttendance(
        studentModel: widget.studentModel,
       
        className: widget.className,
      ),
    ];
  }
}
