
import 'package:collegify/database/databaseService.dart';
import 'package:collegify/shared/components/constants.dart';
import 'package:collegify/shared/components/dropDownList.dart';
import 'package:collegify/shared/components/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OpenAddNewSemesterDialog extends StatefulWidget {
  const OpenAddNewSemesterDialog({
    Key key,
  }) : super(key: key);
  @override
  _OpenAddNewSemesterDialogState createState() =>
      _OpenAddNewSemesterDialogState();
}

class _OpenAddNewSemesterDialogState extends State<OpenAddNewSemesterDialog> {
  DatabaseService _databaseService = new DatabaseService();
  final _formkey = GlobalKey<FormState>();
  bool _loading = false;

  String _selectedDepartmentName;
  String _selectedCourseName;
  String _selectedSemester;
  String _newSemester;

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: HeadingText(
              text: collegeName,
              size: 20.0,
              color: Colors.black54,
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
                        _selectedCourseName = null;
                      });
                    },
                    selectedDepartmentName: _selectedDepartmentName,
                  ),
                  DropDownListForCourseNames(
                    // hintText: "View Courses",

                    departmentName: _selectedDepartmentName,
                    selectedCourseName: _selectedCourseName,
                    onpressed: (val) {
                      setState(() {
                        _selectedCourseName = val;
                        _selectedSemester = null;
                      });
                    },
                  ),
                  DropDownListForYearData(
                      hintText: "View Semester",
                      departmentName: _selectedDepartmentName,
                      courseName: _selectedCourseName,
                      selectedYear: _selectedSemester,
                      onpressed: (val) {
                        // setState(() {
                        //   _selectedSemester = val;
                        // });
                      }),
                  RoundedInputField(
                    hintText: 'Add Semester',
                    color: Colors.white,
                    onChanged: (val) {
                      setState(() {
                        _newSemester = val;
                      });
                    },
                    validator: (val) => RegExp(r'^[0-9]*$').hasMatch(val)
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
                    icon: Icon(Icons.done),
                    onPressed: () async {
                      if (_formkey.currentState.validate() &&
                          _selectedDepartmentName != null &&
                          _selectedCourseName != null &&
                          _newSemester != null &&
                          _newSemester.isNotEmpty) {
                        setState(() {
                          _loading = !_loading;
                        });
                        dynamic result = await _databaseService.addNewYear(
                          _selectedDepartmentName,
                          _selectedCourseName,
                          _newSemester,
                        );

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
