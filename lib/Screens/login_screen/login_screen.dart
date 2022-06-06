import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../authentication/auth_service.dart';
import '../../shared/components/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final _formkey = GlobalKey<FormState>();

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message;
  bool _obscureText = true;
  final AuthService _authService = AuthService();
  bool loading = false;

  void unfocus() {
    if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
    _formkey.currentState.reset();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: unfocus,
      child: Scaffold(
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: size.height * 0.125),
                    SizedBox(height: size.height * 0.0325),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      width: size.width * 0.8,
                      child: HeadingText(
                        alignment: Alignment.centerLeft,
                        text: 'Welcome to',
                        fontWeight: FontWeight.w200,
                        size: 30,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: 5,
                      ),
                      width: size.width * 0.8,
                      child: HeadingText(
                        alignment: Alignment.centerLeft,
                        text: 'Collegify!',
                        fontWeight: FontWeight.bold,
                        size: 50,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    SizedBox(height: size.height * 0.0325),
                    RoundedInputField(
                      controller: _emailController,
                      hintText: "Email",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      validator: (val) => val.isEmpty
                          ? 'Oops! you left this field empty'
                          : null,
                      // onChanged: (val) {
                      //   email = val;
                      // },
                    ),
                    RoundedInputField(
                      hintText: "Password",
                      controller: _passwordController,
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
                      validator: (val) => val.isEmpty ? "Can't be empty" : null,
                      boolean: _obscureText,
                      // onChanged: (val) {
                      //   password = val;
                      // },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    RoundedButton(
                      text: 'Log In',
                      onPressed: loginUser,
                      color: Theme.of(context).colorScheme.secondary,
                      loading: loading,
                      textColor: Colors.white,
                    ),
                    SizedBox(
                      height: 20,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  loginUser() async {
    if (_formkey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      dynamic result = await _authService.loginWithEmailpasswd(
          _emailController.text.trim(), _passwordController.text.trim());
      if (this.mounted)
        setState(() {
          loading = false;
        });
      if (result != null)
        setState(() {
          _message = result.toString();
        });
    }
  }
}
