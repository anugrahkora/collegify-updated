import 'package:collegify/Screens/admin_screen/Announcements/createAdminAnnouncement.dart';
import 'package:collegify/Screens/admin_screen/ListViewScreens/parentListViewScreen.dart';
import 'package:collegify/Screens/admin_screen/ListViewScreens/studentListViewScreen.dart';
import 'package:collegify/Screens/admin_screen/ListViewScreens/teachersListViewScreen.dart';
import 'package:collegify/Screens/admin_screen/adminAuthScreen.dart/adminRegisterScreen.dart';
import 'package:collegify/Screens/admin_screen/admin_home.dart';
import 'package:collegify/Screens/admin_screen/popups/coursePopup.dart';
import 'package:collegify/Screens/admin_screen/popups/departmentPopup.dart';
import 'package:collegify/Screens/admin_screen/popups/feePopup.dart';
import 'package:collegify/Screens/admin_screen/popups/semesterPopup.dart';
import 'package:collegify/shared/components/constants.dart';
import 'package:flutter/material.dart';

class BuildItems extends StatelessWidget {
  const BuildItems({
    Key key,
    @required this.size,
    @required this.widget,
  }) : super(key: key);

  final Size size;
  final AdminHome widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                SizedBox(
                  height: size.height * 0.2,
                  width: size.width * 0.4,
                  child: DecoratedContainer(
                    child: HeadingText(
                      text: 'Add new department',
                      size: 15.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                    onpressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return OpenAddNewDepartmentDialog();
                          });
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.2,
                  width: size.width * 0.4,
                  child: DecoratedContainer(
                    child: HeadingText(
                      text: 'Add new course',
                      size: 15.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                    onpressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return OpenAddNewCourseDialog();
                          });
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.2,
                  width: size.width * 0.4,
                  child: DecoratedContainer(
                    child: HeadingText(
                      text: 'Add new semester',
                      size: 15.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                    onpressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return OpenAddNewSemesterDialog();
                          });
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.2,
                  width: size.width * 0.4,
                  child: DecoratedContainer(
                    child: HeadingText(
                      text: 'Add Fee',
                      size: 15.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                    onpressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return OpenAddFeeDialog();
                          });
                    },
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.2,
                  width: size.width * 0.4,
                  child: DecoratedContainer(
                    child: HeadingText(
                      text: 'View Teachers',
                      size: 15.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                    onpressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => TeacherListViewScreen(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.2,
                  width: size.width * 0.4,
                  child: DecoratedContainer(
                    widthfactor: 0.4,
                    child: HeadingText(
                      text: 'View Students',
                      size: 15.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                    onpressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => StudentListViewScreen(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.2,
                  width: size.width * 0.4,
                  child: DecoratedContainer(
                    widthfactor: 0.4,
                    child: HeadingText(
                      text: 'View Parents',
                      size: 15.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                    onpressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => ParentListViewScreen(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.2,
                  width: size.width * 0.45,
                  child: DecoratedContainer(
                    widthfactor: 0.4,
                    child: HeadingText(
                      text: 'Add Announcement',
                      size: 15.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                    onpressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => CreateAdminAnnouncement(
                            adminModel: widget.adminModel,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        // SizedBox(
        //   height: size.height * 0.2,
        //   width: size.width * 0.9,
        //   child: DecoratedContainer(
        //     widthfactor: 0.4,
        //     child: HeadingText(
        //       text: 'Add Admin',
        //       size: 15.0,
        //       color: Theme.of(context).primaryTextTheme.bodyText1.color,
        //     ),
        //     onpressed: () {
        //       Navigator.of(context, rootNavigator: true).push(
        //         MaterialPageRoute(
        //           builder: (context) => AdminRegisterScreen(),
        //         ),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
