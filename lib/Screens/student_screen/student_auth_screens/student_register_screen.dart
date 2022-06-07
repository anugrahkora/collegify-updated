import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../authentication/auth_service.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/components/dropDownList.dart';

class StudentRegisterScreen extends StatefulWidget {
  StudentRegisterScreen();
  @override
  _StudentRegisterScreenState createState() => _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends State<StudentRegisterScreen> {
  final AuthService _authService = AuthService();

  final _formkey =
      GlobalKey<FormState>(); // this is used for validation purpose
  // String university;
  // String collegeName;
  String departmentName;

  String courseName;
  String name = '';
  String registrationNumber = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  String year;
  String _message;
  bool loading = false;
  bool _obscureText = true;
  // String role = '';

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
                  height: 40.0,
                ),

                Container(
                  child: Center(
                    child: ImageIcon(
                      AssetImage('assets/icons/iconStudentLarge.png'),
                      color: Theme.of(context)
                          .bottomNavigationBarTheme
                          .selectedItemColor,
                      size: 70,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),

                //list of universities
                // DropDownListForUniversityNames(
                //   selectedUniversity: university,
                //   onpressed: (val) {
                //     setState(() {
                //       collegeName = null;
                //       departmentName = null;
                //       courseName = null;
                //       university = val;
                //     });
                //   },
                // ),
                // SizedBox(
                //   height: 5.0,
                // ),
                // list of colleges
                // DropdownListForCollegeName(
                //   universityName: university,
                //   selectedCollegeName: collegeName,
                //   onpressed: (val) {
                //     setState(() {
                //       departmentName = null;
                //       courseName = null;
                //       year = null;
                //       collegeName = val;
                //     });
                //   },
                // ),
                // SizedBox(
                //   height: 5.0,
                // ),
                //list of departments
                DropDownListForDepartmentName(
                  // collegeName: collegeName,
                  selectedDepartmentName: departmentName,
                  onpressed: (val) {
                    setState(() {
                      courseName = null;
                      departmentName = val;
                    });
                  },
                ),

                DropDownListForCourseNames(
                  // collegeName: collegeName,
                  departmentName: departmentName,
                  selectedCourseName: courseName,
                  onpressed: (val) {
                    setState(() {
                      courseName = val;
                      year = null;
                    });
                  },
                ),

                DropDownListForYearData(
                    universityName: university,
                    // collegeName: collegeName,
                    departmentName: departmentName,
                    courseName: courseName,
                    selectedYear: year,
                    onpressed: (val) {
                      setState(() {
                        year = val;
                      });
                    }),

                RoundedInputField(
                  textInputType: TextInputType.name,
                  hintText: 'Name',
                  validator: (val) =>
                      RegExp(r'^[a-zA-Z ]*$').hasMatch(val) && val.isNotEmpty
                          ? null
                          : 'Enter a valid Name',
                  onChanged: (val) {
                    name = val.trim();
                  },
                ),

                RoundedInputField(
                  hintText: 'Registration number',
                  validator: (val) => val.trim().length == 10 &&
                          RegExp(r'^[a-zA-Z0-9]*$').hasMatch(val)
                      ? null
                      : 'enter a valid registration number',
                  onChanged: (val) {
                    registrationNumber = val.trim();
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
                    email = val.trim();
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
                      password = val.trim();
                    }),

                RoundedInputField(
                    hintText: 'Confirm Password',
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    validator: (val) => confirmPassword.trim() != password
                        ? "passwords does'nt match"
                        : null,
                    boolean: true,
                    onChanged: (val) {
                      confirmPassword = val.trim();
                    }),
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
                  text: 'Register as Student',
                  onPressed: registerStudent,
                  color: Theme.of(context).colorScheme.secondary,
                  loading: loading,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  registerStudent() async {
    if (_formkey.currentState.validate()) {
      if (university != null &&
          departmentName != null &&
          courseName != null &&
          year != null) {
        try {
          setState(() {
            loading = true;
          });

          dynamic result = await _authService.studentregisterWithEmailpasswd(
            departmentName,
            courseName,
            year,
            name,
            registrationNumber,
            'student',
            email,
            password,
          );
          if (result != null) {
          } else {
            setState(() {
              loading = false;
              _message = 'error';
            });
          }
        } on FirebaseAuthException catch (e) {
          setState(() {
            _message = e.message.toString();
            loading = false;
          });
        }
      } else {
        setState(() {
          _message = 'please select your insitution data';
        });
      }
    }
  }
}
