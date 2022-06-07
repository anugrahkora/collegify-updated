import 'package:collegify/database/databaseService.dart';
import 'package:collegify/shared/components/constants.dart';
import 'package:collegify/shared/components/dropDownList.dart';
import 'package:collegify/shared/components/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OpenAddNewDepartmentDialog extends StatefulWidget {
  const OpenAddNewDepartmentDialog({
    Key key,
  }) : super(key: key);
  @override
  _OpenAddNewDepartmentDialogState createState() =>
      _OpenAddNewDepartmentDialogState();
}

class _OpenAddNewDepartmentDialogState
    extends State<OpenAddNewDepartmentDialog> {
  bool _loading = false;
  String _newDepartmentName;
  String selectedDepartmentName;
  DatabaseService _databaseService = new DatabaseService();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
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
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropDownListForDepartmentName(
                    hintText: 'View Departments',

                    onpressed: (val) {
                      setState(() {
                        selectedDepartmentName = val;
                      });
                    },
                    // selectedDepartmentName: _selectedDepartmentName,
                  ),
                  RoundedInputField(
                    hintText: 'New Department Name',
                    onChanged: (val) {
                      setState(() {
                        _newDepartmentName = val.replaceAll(' ', '_');
                      });
                    },
                    validator: (val) =>
                        RegExp(r'^[ a-zA-Z0-9 ]*$').hasMatch(val)
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
                    icon: Icon(Icons.done,
                    
                      color: Theme.of(context)
                          .bottomNavigationBarTheme
                          .selectedItemColor,
                    ),
                    onPressed: () async {
                      if (_formkey.currentState.validate() &&
                          _newDepartmentName != null &&
                          _newDepartmentName.isNotEmpty) {
                        setState(() {
                          _loading = !_loading;
                        });
                        dynamic result = await _databaseService
                            .addNewDepartment(_newDepartmentName
                                .toString()
                                .replaceAll(' ', '_'));
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
