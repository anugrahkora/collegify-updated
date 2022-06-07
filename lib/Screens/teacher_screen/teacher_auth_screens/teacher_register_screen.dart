//import 'package:collegify/Screens/teacher_screen/teacher_auth_screens/teacher_login_screen.dart';
import 'package:collegify/authentication/auth_service.dart';
import 'package:collegify/shared/components/constants.dart';
import 'package:collegify/shared/components/dropDownList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TeacherRegisterScreen extends StatefulWidget {
  @override
  _TeacherRegisterScreenState createState() => _TeacherRegisterScreenState();
}

class _TeacherRegisterScreenState extends State<TeacherRegisterScreen> {
  final AuthService _authService = AuthService();
  final _formkey = GlobalKey<FormState>();
  String name = '';

  // String university;
  // String collegeName;
  String departmentName;
  String courseName;
  String semester;
  String email = '';
  String password = '';
  String confirmPassword = '';
  String _message;
  bool loading = false;
  bool _obscureText = true;
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
                AlertWidget(
                  color: Colors.amber,
                  message: _message,
                  onpressed: () {
                    setState(() {
                      _message = null;
                    });
                  },
                ),

                Container(
                  child: Center(
                    child: ImageIcon(
                      AssetImage('assets/icons/iconTeacherLarge.png'),
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
                // DropdownListForCollegeName(
                //   universityName: university,
                //   selectedCollegeName: collegeName,
                //   onpressed: (val) {
                //     setState(() {
                //       departmentName = null;
                //       courseName = null;
                //       collegeName = val;
                //     });
                //   },
                // ),
                // SizedBox(
                //   height: 5.0,
                // ),
                //list of departments
                DropDownListForDepartmentName(
                  // universityName: university,
                  // collegeName: collegeName,
                  selectedDepartmentName: departmentName,
                  onpressed: (val) {
                    setState(() {
                      courseName = null;
                      departmentName = val;
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),

                RoundedInputField(
                  hintText: 'Name',
                  validator: (val) => RegExp(r'^[ a-zA-Z ]*$').hasMatch(val)
                      ? null
                      : 'Enter a valid Name',
                  onChanged: (val) {
                    name = val.trim();
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
                  },
                ),

                RoundedInputField(
                    hintText: 'Confirm Password',
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    validator: (val) =>
                        val != password ? "passwords does'nt match" : null,
                    boolean: true,
                    onChanged: (val) {
                      confirmPassword = val;
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
                  text: 'Register as Teacher',
                  onPressed: teacherRegister,
                  color: Theme.of(context).colorScheme.secondary,
                  loading: loading,
                  textColor: Colors.white,
                ),

                SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  teacherRegister() async {
    if (_formkey.currentState.validate()) {
      if (university != null && departmentName != null) {
        setState(() {
          loading = true;
        });
        try {
          await _authService.teacherregisterWithEmailpasswd(
              departmentName, name, email, password, 'teacher');
        } on FirebaseAuthException catch (e) {
          setState(() {
            _message = e.message;
            loading = false;
          });
        }
        if (this.mounted)
          setState(() {
            loading = false;
          });
      }
    }
  }
}
