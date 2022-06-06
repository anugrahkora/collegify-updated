//import 'package:collegify/Screens/parent_screen/parent_login_screen.dart';
import 'package:collegify/authentication/auth_service.dart';
import 'package:collegify/shared/components/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ParentRegisterScreen extends StatefulWidget {
  @override
  _ParentRegisterScreenState createState() => _ParentRegisterScreenState();
}

class _ParentRegisterScreenState extends State<ParentRegisterScreen> {
  final _formkey = GlobalKey<FormState>();
  bool _loading = false;
  // String _university;
  // String _collegeName;
  // String _departmentName;
  bool _obscureText = true;
  // String _courseName;
  // String _semester;
  String _parentName = '';
  // String _wardName = '';
  String _registrationNumber = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _message;
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: HexColor(appPrimaryColour),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  child: Center(
                    child: ImageIcon(
                      AssetImage('assets/icons/iconParentLarge.png'),
                      color: Colors.black54,
                      size: 70,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                // DropDownListForUniversityNames(
                //   selectedUniversity: _university,
                //   onpressed: (val) {
                //     setState(() {
                //       _collegeName = null;
                //       _departmentName = null;
                //       _courseName = null;
                //       _university = val;
                //     });
                //   },
                // ),
                // SizedBox(
                //   height: 5.0,
                // ),
                // DropdownListForCollegeName(
                //   universityName: _university,
                //   selectedCollegeName: _collegeName,
                //   onpressed: (val) {
                //     setState(() {
                //       _departmentName = null;
                //       _courseName = null;
                //       _collegeName = val;
                //     });
                //   },
                // ),
                // SizedBox(
                //   height: 5.0,
                // ),
                // DropDownListForDepartmentName(
                //   universityName: _university,
                //   collegeName: _collegeName,
                //   selectedDepartmentName: _departmentName,
                //   onpressed: (val) {
                //     setState(() {
                //       _courseName = null;
                //       _semester = null;
                //       _departmentName = val;
                //     });
                //   },
                // ),
                // SizedBox(
                //   height: 5.0,
                // ),
                // DropDownListForCourseNames(
                //   universityName: _university,
                //   collegeName: _collegeName,
                //   departmentName: _departmentName,
                //   selectedCourseName: _courseName,
                //   onpressed: (val) {
                //     setState(() {
                //       _courseName = val;
                //       _semester = null;
                //     });
                //   },
                // ),
                // SizedBox(
                //   height: 5.0,
                // ),
                // DropDownListForYearData(
                //     universityName: _university,
                //     collegeName: _collegeName,
                //     departmentName: _departmentName,
                //     courseName: _courseName,
                //     selectedYear: _semester,
                //     onpressed: (val) {
                //       setState(() {
                //         _semester = val;
                //       });
                //     }),
                RoundedInputField(
                  hintText: 'Parent name',
                  validator: (val) => RegExp(r'^[ a-zA-Z ]*$').hasMatch(val)
                      ? null
                      : 'Enter a valid Name',
                  onChanged: (val) {
                    _parentName = val.trim();
                  },
                ),

                // RoundedInputField(
                //   hintText: 'Ward name',
                //   validator: (val) => RegExp(r'^[ a-zA-Z ]*$').hasMatch(val)
                //       ? null
                //       : 'Enter a valid Name',
                //   onChanged: (val) {
                //     _wardName = val.trim();
                //   },
                // ),
                // SizedBox(
                //   height: 5.0,
                // ),
                RoundedInputField(
                  hintText: 'Register number',
                  validator: (val) => val.trim().length == 10 &&
                          RegExp(r'^[a-zA-Z0-9]*$').hasMatch(val)
                      ? null
                      : 'enter a valid registration number',
                  onChanged: (val) {
                    _registrationNumber = val.trim();
                  },
                ),

                RoundedInputField(
                  hintText: 'Email',
                  prefixIcon: Icon(
                    Icons.email,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  validator: (val) =>
                      RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(val)
                          ? null
                          : 'Please enter a valid email',
                  onChanged: (val) {
                    _email = val.trim();
                  },
                ),

                RoundedInputField(
                    hintText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    suffixIcon: IconButton(
                      icon: _obscureText
                          ? Icon(
                              Icons.visibility,
                              color: Theme.of(context).colorScheme.secondary,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    validator: (val) => val.length < 6
                        ? 'provide a password 6 character long'
                        : null,
                    boolean: _obscureText,
                    onChanged: (val) {
                      _password = val;
                    }),

                RoundedInputField(
                    hintText: 'Confirm Password',
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    validator: (val) => _confirmPassword != _password
                        ? "passwords does'nt match"
                        : null,
                    boolean: true,
                    onChanged: (val) {
                      _confirmPassword = val;
                    }),
                SizedBox(
                  height: 15.0,
                ),
                AlertWidget(
                  color: Colors.amber,
                  message: _message,
                  onpressed: () {
                    setState(() {
                      _message = null;
                    });
                  },
                ),
                RoundedButton(
                  text: 'Register as Parent',
                  onPressed: registerParent,
                  color:Theme.of(context).colorScheme.secondary,
                  loading: _loading,
                  textColor: Colors.white,
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  registerParent() async {
    if (_formkey.currentState.validate()) {
      try {
        setState(() {
          _loading = true;
        });

        dynamic result = await _authService.parentRegisterWithEmailPassword(
          // _university,
          // _collegeName,
          // _departmentName,
          // _courseName,
          // _semester,
          _parentName,
          // _wardName,
          _registrationNumber,
          'checkStudent',
          _email,
          _password,
        );
        if (result != null) {
          _loading = false;
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _message = e.message.toString();
          _loading = false;
        });
      }
    }
  }
}
