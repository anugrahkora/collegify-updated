import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegify/database/databaseService.dart';
import 'package:collegify/shared/components/constants.dart';
import 'package:collegify/shared/components/dropDownList.dart';
import 'package:collegify/shared/components/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OpenAddFeeDialog extends StatefulWidget {
  const OpenAddFeeDialog({
    Key key,
  }) : super(key: key);
  @override
  _OpenAddFeeDialogState createState() => _OpenAddFeeDialogState();
}

class _OpenAddFeeDialogState extends State<OpenAddFeeDialog> {
  final _formkey = GlobalKey<FormState>();
  bool _loading = false;
  DatabaseService _databaseService = new DatabaseService();
  String _selectedDepartmentName;
  String _selectedCourseName;
  String _selectedSemester;
  String _fee;

  Future _getFee(String department, String courseName, String semester) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      await firebaseFirestore
          .collection(college)
          .doc(department)
          .collection('CourseNames')
          .doc(courseName)
          .collection('Semester')
          .doc(semester)
          .get()
          .then((docs) {
        if (docs.exists) {
          _fee = docs.data()['Fee'];
        }
      });
      return _fee;
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message);
    }
  }

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
              size: 15.0,
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
                        _selectedCourseName = null;
                        _selectedSemester = null;
                        _fee = null;
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
                        _fee = null;
                      });
                    },
                  ),
                  DropDownListForYearData(
                      // hintText: "View Semester",

                      departmentName: _selectedDepartmentName,
                      courseName: _selectedCourseName,
                      selectedYear: _selectedSemester,
                      onpressed: (val) {
                        setState(() {
                          _selectedSemester = val;
                          _fee = null;
                        });
                      }),
                  FutureBuilder(
                      future: _getFee(_selectedDepartmentName,
                          _selectedCourseName, _selectedSemester),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Loader(
                            size: 10.0,
                            spinnerColor: Colors.black54,
                          );
                        }
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              PlaceHolderContainer(
                                text: '₹' + ' ' + snapshot.data,
                              ),
                              RoundedInputField(
                                textInputType: TextInputType.number,
                                hintText: 'Update Fee',
                                color: Colors.white,
                                onChanged: (val) {
                                  _fee = val;
                                },
                                validator: (val) =>
                                    RegExp(r'^[0-9]*$').hasMatch(val) &&
                                            val.isNotEmpty
                                        ? null
                                        : 'Not allowed',
                              ),
                            ],
                          );
                        }
                        if (!snapshot.hasData && _selectedSemester == null)
                          return PlaceHolderContainer(text: 'Select Semester');
                        return Column(
                          children: [
                            PlaceHolderContainer(text: 'Fee Not Added'),
                            RoundedInputField(
                              textInputType: TextInputType.number,
                              hintText: 'Add Fee',
                              color: Colors.white,
                              onChanged: (val) {
                                _fee = val;
                              },
                              validator: (val) =>
                                  RegExp(r'^[0-9]*$').hasMatch(val)
                                      ? null
                                      : 'Not allowed',
                            ),
                          ],
                        );
                      }),
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
                          _selectedCourseName != null &&
                          _fee != null &&
                          _fee.isNotEmpty) {
                        setState(() {
                          _loading = true;
                        });
                        dynamic result = await _databaseService.addFee(
                          _selectedDepartmentName,
                          _selectedCourseName,
                          _selectedSemester,
                          _fee,
                        );

                        if (result != null)
                          Fluttertoast.showToast(msg: result.toString());
                        else {
                          Fluttertoast.showToast(msg: "Done");
                          setState(() {
                            _loading = !_loading;
                          });
                          // Navigator.of(context, rootNavigator: true).pop();
                        }
                      }
                    })
          ],
        ),
      ),
    );
  }
}

class PlaceHolderContainer extends StatelessWidget {
  final String text;
  const PlaceHolderContainer({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(top: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.amber,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: HeadingText(
          // alignment: Alignment.centerLeft,
          text: text,
          size: 17.0,
          color: Colors.black,
        ),
      ),
    );
  }
}
