
import 'package:collegify/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../shared/components/constants.dart';
import 'admin_home.dart';
import 'admin_verify_teacher.dart';

PersistentTabController _controller = PersistentTabController(initialIndex: 0);

class AdminNavigationScreen extends StatefulWidget {
  final AdminModel adminModel;

  const AdminNavigationScreen({Key key, this.adminModel})
      : super(key: key);
  @override
  _AdminigationScreenState createState() => _AdminigationScreenState();
}

class _AdminigationScreenState extends State<AdminNavigationScreen> {
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.add),
        title: ("Add Institutions"),
        activeColor: CupertinoColors.darkBackgroundGray,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.check_mark_circled),
        title: ('Profile'),
        activeColor: CupertinoColors.darkBackgroundGray,
        inactiveColor: CupertinoColors.systemGrey,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      AdminHome(
        adminModel: widget.adminModel,
      ),
      AdminVerifyTeacherScreen(
       adminModel: widget.adminModel,
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
          false, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
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
}
