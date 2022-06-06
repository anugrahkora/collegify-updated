import 'package:collegify/Screens/teacher_screen/teacher_home/Classes_screens/openMoreOptionPopup.dart';
import 'package:collegify/models/user_model.dart';
import 'package:collegify/shared/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

class EditStudentScreen extends StatefulWidget {
  final TeacherModel teacherModel;
  final String className;
  final String semester;
  final String courseName;
  final String studentName;
  final String studentRollNumber;
  final String studentCurrentSemeter;
  final String studentCurrentCourse;
  final String studentUID;
  const EditStudentScreen({
    Key key,
    @required this.teacherModel,
    @required this.className,
    @required this.semester,
    @required this.courseName,
    @required this.studentName,
    @required this.studentRollNumber,
    @required this.studentCurrentSemeter,
    @required this.studentCurrentCourse,
    @required this.studentUID,
  }) : super(key: key);
  @override
  _EditStudentScreenState createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black54),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: HeadingText(
          alignment: Alignment.centerLeft,
          text: 'Edit Student Info',
          size: 17.0,
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
        ),
      ),
      // backgroundColor: HexColor(appPrimaryColour),
      body: Column(
        children: [
          DecoratedCard(
            onTap: () {},
            child: Row(
              children: [
                ImageIcon(
                  AssetImage('assets/icons/iconStudentLarge.png'),
                  color: Colors.black54,
                  size: 50,
                ),
                SizedBox(
                  width: 30.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingText(
                      alignment: Alignment.centerLeft,
                      text: widget.studentName,
                      size: 15.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                    HeadingText(
                      alignment: Alignment.centerLeft,
                      text: widget.studentRollNumber,
                      size: 15.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                    HeadingText(
                      alignment: Alignment.centerLeft,
                      text: widget.studentCurrentCourse.replaceAll('_', ' '),
                      size: 15.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                    HeadingText(
                      alignment: Alignment.centerLeft,
                      text: 'Semester' + ' ' + widget.studentCurrentSemeter,
                      size: 15.0,
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                    ),
                  ],
                ),
              ],
            ),
          ),
          DecoratedCard(
            color: Colors.amber,
            onTap: () {
              try {
                showDialog(
                    context: context,
                    builder: (_) {
                      return OpenOptionPopUp(
                          studentUID: widget.studentUID,
                          teacherModel: widget.teacherModel,
                          registrationNumber: widget.studentRollNumber,
                          courseName: widget.courseName);
                    });
              } catch (e) {
                Fluttertoast.showToast(msg: e.toString());
              }
            },
            child: HeadingText(
              alignment: Alignment.centerLeft,
              text: 'Change Semester',
              size: 15.0,
              color: Theme.of(context).primaryTextTheme.bodyText1.color,
            ),
          ),
          // DecoratedCard(
          //   color: Colors.redAccent,
          //   onTap: () {},
          //   child: HeadingText(
          //     alignment: Alignment.centerLeft,
          //     text: 'Delete User',
          //     size: 15.0,
          //     color: HexColor(appPrimaryColourLight),
          //   ),
          // )
        ],
      ),
    );
  }
}
