import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Model.dart';
import '../../../User/ScreenUser/HomeScreenUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../CRUD/passcode.dart';
import '../SignupScreen/SignupScreen.dart';
import 'forget_pass.dart';
import 'loginScreenAdmin.dart';



class LoginScreen extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  bool _isObscure3 = true;
  bool visible = false;
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _savedEmail;
  String? _savedPassword;
  late SharedPreferences logindata;
  late bool newuser;

  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final userdata = GetStorage();
  final _auth = FirebaseAuth.instance;

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _rememberMe = prefs.getBool('rememberMe') ?? true;
        if (_rememberMe) {
          _savedEmail = prefs.getString('email');
          _savedPassword = prefs.getString('password');
          emailController.text = _savedEmail ?? '';
          passwordController.text = _savedPassword ?? '';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            _handleTripleTap(); // Call function to handle triple tap
                          },
                          child: Center(
                            child: Image.asset(
                              'assets/images/logo1.png',
                              height: 200,
                              width: 250,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Welcome ",
                            style: GoogleFonts.dancingScript(
                              textStyle: Theme.of(context).textTheme.displayLarge,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.deepPurple,),
                              borderRadius: BorderRadius.circular(5.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.deepPurple,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.deepPurple,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "E-Mail",
                            labelStyle: TextStyle(
                              color: Colors.deepPurple,),
                          ),
                          validator: (value) {
                            if (value!.length == 0) {
                              return "Email cannot be empty";
                            }
                            if (!RegExp(
                                "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please enter a valid email");
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            emailController.text = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: _isObscure3,
                          controller: passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure3
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure3 = !_isObscure3;
                                  });
                                }),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.deepPurple,),
                              borderRadius: BorderRadius.circular(5.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.fingerprint,
                                color: Colors.deepPurple,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: Colors.deepPurple,),
                          ),
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (!regex.hasMatch(value)) {
                              return ("please enter valid password min. 6 character");
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            passwordController.text = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CheckboxListTile(
                          title: Text('Remember me'),
                          value: _rememberMe,
                          onChanged: (newValue) {
                            setState(() {
                              _rememberMe = newValue!;
                              if (!_rememberMe) {
                                _savedEmail = null;
                                _savedPassword = null;
                                emailController.clear();
                                passwordController.clear();
                              }
                              SharedPreferences.getInstance().then((prefs) {
                                prefs.setBool('rememberMe', _rememberMe);
                                if (_rememberMe) {
                                  prefs.setString(
                                      'email', emailController.text);
                                  prefs.setString(
                                      'password', passwordController.text);
                                } else {
                                  prefs.remove('email');
                                  prefs.remove('password');
                                }
                              });
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return ForgotPassPage();
                                    },),);
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 60.00,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                )
                            ),
                            onPressed: () async {
                              final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                              sharedPreferences.setString('email', emailController.text);
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                await signIn(
                                  emailController.text,
                                  passwordController.text,
                                );
                              }
                            },
                            child: Text('Login'),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 50,),
                        // Align(
                        //   alignment: Alignment.center,
                        //   child: Visibility(
                        //       maintainSize: true,
                        //       maintainAnimation: true,
                        //       maintainState: true,
                        //       visible: visible,
                        //       child: Container(
                        //           child: CircularProgressIndicator(
                        //             color: Colors.deepPurple,
                        //           )
                        //       )
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return SignupScreen();
                                    },),);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'Don`t have an Account?',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'SignUp',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "User") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreenUser(),
            ),
          );
        } else {
          print('Document does not exist on the database');
        }
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User user = userCredential.user!;
      setState(() {
        _isLoading = false;
      });
      if (_rememberMe) {
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('email', email);
          prefs.setString('password', password);
        });
      }
      route();
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user found for that email.')),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wrong password provided for that user.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wrong Password or Email. Please try again.')),
        );
      }
    }
  }

  int _tapCount = 0;
  final _tapGestureRecognizer = TapGestureRecognizer();

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  void _handleTripleTap() {
    _tapCount++;
    if (_tapCount == 3) {
      _showCodeInputDialog();
      _tapCount = 0; // Reset tap count
    }
  }

  void _showCodeInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String code = '';
        return AlertDialog(
          title: Text('Enter Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 1.5,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  if (index == 9) {
                    // Last grid item is 'Cancel' button
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context); // Dismiss the dialog
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.cancel,
                          size: 32,
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else {
                    // Digits 0-9 as grid items
                    return InkWell(
                      onTap: () {
                        if (code.length < 4) {
                          setState(() {
                            code += index.toString();
                          });
                          if (code.length == 4) {
                            // If all fields are filled, validate the code
                            _validateCode(code);
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          index.toString(),
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 16),
              Text(
                'Tap to enter each digit',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  void _validateCode(String code) async {
    final codeRepo = CodeRepository();

    // Check if the code is not empty
    if (code.isNotEmpty && code.length == 4) {
      // Correct code, navigate to loginAdmin page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreenAdmin()),
      );
    } else {
      // Incorrect code or empty, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid code. Please enter a 4-digit code.',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }
}
