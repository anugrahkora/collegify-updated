import 'package:collegify/database/databaseService.dart';
import 'package:collegify/shared/components/constants.dart';
import 'package:collegify/shared/components/dropDownList.dart';
import 'package:collegify/shared/components/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OpenAddNewCourseDialog extends StatefulWidget {
  const OpenAddNewCourseDialog({
    Key key,
  }) : super(key: key);
  @override
  _OpenAddNewCourseDialogState createState() => _OpenAddNewCourseDialogState();
}

class _OpenAddNewCourseDialogState extends State<OpenAddNewCourseDialog> {
  DatabaseService _databaseService = new DatabaseService();
  final _formkey = GlobalKey<FormState>();
  bool _loading = false;
  String _newCourseName;
  String _selectedCourseName;
  String _selectedDepartmentName;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: HeadingText(
              text: collegeName,
              size: 20.0,
              color: Theme.of(context).primaryTextTheme.bodyText1.color,
            ),
          ),
          content: Container(
            // height: size.height * 0.25,
            // color: HexColor(appPrimaryColour),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropDownListForDepartmentName(
                    // hintText: 'View Departments',

                    onpressed: (val) {
                      setState(() {
                        _selectedDepartmentName = val;
                      });
                    },
                    selectedDepartmentName: _selectedDepartmentName,
                  ),
                  DropDownListForCourseNames(
                    hintText: "View Courses",
                    departmentName: _selectedDepartmentName,
                    selectedCourseName: _selectedCourseName,
                    onpressed: (val) {
                      // setState(() {
                      //   _selectedCourseName = val;
                      // });
                    },
                  ),
                  RoundedInputField(
                    hintText: 'New Course Name',
                    color: Colors.white,
                    onChanged: (val) {
                      setState(() {
                        _newCourseName = val.replaceAll(' ', '_');
                      });
                    },
                    validator: (val) => RegExp(r'^[a-zA-Z0-9 ]*$').hasMatch(val)
                        ? null
                        : 'Not allowed',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            _loading
                ? Loader(
                    color: Colors.white,
                    spinnerColor: Colors.black54,
                    size: 24,
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
                          _selectedDepartmentName != null &&
                          _newCourseName != null &&
                          _newCourseName.isNotEmpty) {
                        setState(() {
                          _loading = !_loading;
                        });
                        dynamic result = await _databaseService.addNewCourse(
                            _selectedDepartmentName,
                            _newCourseName.toString().replaceAll(' ', '_'));

                        if (result != null)
                          Fluttertoast.showToast(msg: result.toString());
                        else {
                          Fluttertoast.showToast(msg: "Done");
                          setState(() {
                            _loading = !_loading;
                          });
                        }
                      }
                    })
          ],
        ),
      ),
    );
  }
}
