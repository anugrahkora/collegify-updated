import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/models/user_model.dart';
import 'package:collegify/shared/components/loadingWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'announcements_from_teacher.dart';
import 'fee_payment_screen.dart';
import 'student_classes.dart';

PersistentTabController _controller = PersistentTabController(initialIndex: 0);

class ParentNavigationScreen extends StatefulWidget {
  final ParentModel parentModel;

  const ParentNavigationScreen({Key key, @required this.parentModel})
      : super(key: key);
  @override
  _ParentNavigationScreenState createState() => _ParentNavigationScreenState();
}

class _ParentNavigationScreenState extends State<ParentNavigationScreen> {
  StudentModel wardModel;
  Future _getWardData() async {
    DocumentSnapshot doc;
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore
          .collection('users')
          .where('Registration_Number', isEqualTo: widget.parentModel.regNumber)
          .where('Role', isEqualTo: 'student')
          .get()
          .then(
        (value) {
          value.docs.forEach((element) {
            doc = element;
            if (this.mounted)
              setState(() {
                wardModel = StudentModel(
                    name: element.data()['Name'],
                    department: element.data()['Department'],
                    course: element.data()['Course'],
                    semester: element.data()['Semester'],
                    regNumber: element.data()['Registration_Number']);
              });
          });
        },
      );
      return doc;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.book,
          color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        ),
        title: ("Classes"),
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
        title: ("Announcements"),
        activeColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        inactiveColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        activeContentColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.money_dollar,
          color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        ),
        title: ("Fee"),
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
    return FutureBuilder(
        future: _getWardData(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return PersistentTabView(
              controller: _controller,
              screens: _buildScreens(StudentModel(
                  name: snapshot.data['Name'],
                  department: snapshot.data['Department'],
                  course: snapshot.data['Course'],
                  semester: snapshot.data['Semester'],
                  regNumber: snapshot.data['Registration_Number'])),
              items: _navBarsItems(),
              confineInSafeArea: true,
              backgroundColor: Theme.of(context).primaryColor,
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
              navBarStyle: NavBarStyle
                  .style6, // Choose the nav bar style with this property.
            );
          return Loader(
            size: 20.0,
            color: Theme.of(context).primaryColor,
            spinnerColor: Colors.black54,
          );
        });
  }

  List<Widget> _buildScreens(StudentModel wardModel) {
    return [
      StudentAttendanceStatus(
        parentModel: widget.parentModel,
        wardModel: wardModel,
      ),
      AnnouncementFromTeacher(
        parentModel: widget.parentModel,
        wardModel: wardModel,
      ),
      FeePaymentScreen(
        parentModel: widget.parentModel,
        wardModel: wardModel,
      ),
    ];
  }
}
