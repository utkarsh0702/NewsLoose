// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:NewsLoose/screens/main screens/nav.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  // Shared Preferences
  SharedPreferences localStorage;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ignore: non_constant_identifier_names
  void change_value() async {
    localStorage = await SharedPreferences.getInstance();
    await localStorage.setBool('login', false);
  }

  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  bool val = true;
  //----------------------- Text Controllers------------------//
  var emailtextController = TextEditingController();
  var passtextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passtextController.dispose();
    emailtextController.dispose();
    super.dispose();
  }

  void removeLogInError() {
    setState(() {
      errors.remove("Login Failed.");
      errors.remove("Please check your email and password");
    });
  }

  void removeError() {
    setState(() {
      errors.remove("No such account found");
    });
  }

  _showDialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              )
            ],
          );
        });
  }

  void _loginInWithEmailAndPassword() async {
    try {
      FirebaseUser user = (await _auth.signInWithEmailAndPassword(
        email: emailtextController.text,
        password: passtextController.text,
      ))
          .user;
      if (user != null) {
        change_value();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => NavBar(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      print('Error is: $e');
      emailtextController.text = "";
      passtextController.text = "";
      _showDialog('LogIn Error', 'Please check your email and password.');
    }
  }

  //------------------------------Form Feilds---------------------//

  Widget formFields(String text, IconData icon, bool pass) {
    return Padding(
        padding: const EdgeInsets.only(
            top: 20.0, bottom: 10.0, right: 30.0, left: 30.0),
        child: TextFormField(
            keyboardType: pass == false
                ? TextInputType.emailAddress
                : TextInputType.visiblePassword,
            onChanged: (value) {
              if (value.isNotEmpty && errors.contains("Cannot be Empty")) {
                setState(() {
                  errors.remove("Cannot be Empty");
                });
              }
              if (pass == true) {
                if (value.length >= 6 &&
                    errors.contains(
                        "Password should have atleast 6 characters.")) {
                  setState(() {
                    errors.remove("Password should have atleast 6 characters.");
                  });
                }
              }
              if (pass == false) {
                if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value) &&
                    errors.contains("Invalid Email Id.")) {
                  setState(() {
                    errors.remove("Invalid Email Id.");
                  });
                }
              }
            },
            validator: (value) {
              if (value.isEmpty && !errors.contains("Cannot be Empty")) {
                setState(() {
                  errors.add("Cannot be Empty");
                });
                return null;
              }
              if (pass == true) {
                if (value.length < 6 &&
                    !errors.contains(
                        "Password should have atleast 6 characters.")) {
                  setState(() {
                    errors.add("Password should have atleast 6 characters.");
                  });
                  return null;
                }
              }
              if (pass == false) {
                if (!(RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) &&
                    !errors.contains("Invalid Email Id.")) {
                  setState(() {
                    errors.add("Invalid Email Id.");
                  });
                  return null;
                }
              }
              return null;
            },
            obscureText: (pass == true && val == true) ? true : false,
            controller:
                (pass == true) ? passtextController : emailtextController,
            style: TextStyle(decoration: TextDecoration.none),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colors.white,
              ),
              hintText: text,
              hintStyle: TextStyle(color: Colors.white60),
              suffixIcon: pass == true
                  ? IconButton(
                      icon: (val == true)
                          ? Icon(
                              LineAwesomeIcons.eye,
                              color: Colors.white,
                            )
                          : Icon(
                              LineAwesomeIcons.eye_slash,
                              color: Colors.white,
                            ),
                      onPressed: () {
                        setState(() {
                          val = !val;
                        });
                      })
                  : Icon(null),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(width: 2.0, color: Colors.white)),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.99, 0.5),
              colors: [
                Colors.blue,
                Colors.lightBlueAccent,
              ],
              tileMode: TileMode.repeated),
        ),
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Log In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    letterSpacing: .5,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Langar',
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Pacifico',
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  formFields('Email', Icons.email, false),
                  formFields('Password', Icons.lock, true),
                  Row(
                    children: [
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 30.0, top: 10.0, bottom: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/forgot');
                          },
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(
                                  color: Colors.deepPurple[800],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (errors.isNotEmpty)
                    ErrorLine(
                      errors: errors,
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 70,
                      child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate() &&
                                errors.isEmpty) {
                              _loginInWithEmailAndPassword();
                            }
                          },
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Theme.of(context).accentColor,
                                  width: 3.0),
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'LogIn',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  fontFamily: 'Pacifico'),
                            ),
                          )),
                    ),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an Account ? ",
                    style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900])),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      "Create Account ",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    ));
  }
}

//------------------------Error List----------------------//

class ErrorLine extends StatelessWidget {
  const ErrorLine({
    Key key,
    @required this.errors,
  }) : super(key: key);
  final List<String> errors;

  Widget errorLine(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 30.0, right: 30.0),
      child: Row(
        children: [
          Icon(
            Icons.error,
            size: 18.0,
            color: Colors.red[900],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                text,
                style: TextStyle(color: Colors.red[900]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          List.generate(errors.length, (index) => errorLine(errors[index])),
    );
  }
}
