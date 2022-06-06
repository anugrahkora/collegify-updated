
import 'package:collegify/authentication/auth_service.dart';
import 'package:collegify/shared/components/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

class AdminRegisterScreen extends StatefulWidget {
  

  const AdminRegisterScreen({Key key, })
      : super(key: key);
  @override
  _AdminRegisterScreenState createState() => _AdminRegisterScreenState();
}

class _AdminRegisterScreenState extends State<AdminRegisterScreen> {
  final AuthService _authService = AuthService();
  final _formkey = GlobalKey<FormState>();
  String name = '';
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
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  HeadingText(
                    text: 'Add Admin',
                    color: Theme.of(context).colorScheme.secondary,
                    size: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                  AlertWidget(
                    message: _message,
                    onpressed: () {
                      setState(() {
                        _message = null;
                      });
                    },
                    color: Colors.amber,
                  ),
                  RoundedInputField(
                    hintText: 'Name',
                    validator: (val) => RegExp(r'^[a-zA-Z]*$').hasMatch(val)
                        ? null
                        : 'Enter a valid Name',
                    onChanged: (val) {
                      name = val.trim();
                    },
                  ),
                  RoundedInputField(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    validator: (val) =>
                        RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                                .hasMatch(val)
                            ? null
                            : 'Please enter a valid email',
                    onChanged: (val) {
                      email = val.trim();
                    },
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  RoundedInputField(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: _obscureText
                          ? Icon(
                              Icons.remove_red_eye,
                              color: Theme.of(context).colorScheme.secondary,
                            )
                          : Icon(
                              Icons.remove_red_eye,
                              color: Theme.of(context).primaryColor,
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
                  SizedBox(
                    height: 5.0,
                  ),
                  RoundedInputField(
                      hintText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock),
                      validator: (val) =>
                          val != password ? "passwords does'nt match" : null,
                      boolean: true,
                      onChanged: (val) {
                        confirmPassword = val;
                      }),
                  RoundedButton(
                    text: 'Register as Admin',
                    onPressed: () async {
                      if (_formkey.currentState.validate()) {
                        setState(() {
                          loading = true;
                        });
                        try {
                          dynamic result =
                              await _authService.adminRegisterWithEmailPassword(
                                
                                  name,
                                  email,
                                  password);

                          if (result != null) {
                            setState(() {
                              loading = false;
                            });
                            Fluttertoast.showToast(msg: result.toString());
                          } else {
                            setState(() {
                              loading = false;
                            });
                            Fluttertoast.showToast(
                                msg: '$name has successfully made an admin');
                          }
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            _message = e.message;
                            loading = false;
                          });
                        }
                      }
                    },
                    color: Theme.of(context).colorScheme.secondary,
                    loading: loading,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
