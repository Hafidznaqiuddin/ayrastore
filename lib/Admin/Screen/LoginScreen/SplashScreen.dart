import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Model.dart';
import '../../../User/ScreenUser/HomeScreenUser.dart';
import '../HomeScreen.dart';
import '../LoginScreen/loginScreen.dart';
import 'loginScreenAdmin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String? finalEmail;
  late bool isAdmin;

  @override
  void initState() {
    super.initState();
    _redirectUser();
  }

  Future<void> _redirectUser() async {
    await getValidationData();
    if (finalEmail != null) {
      if (isAdmin) {
        Timer(Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ModelScreenManage(),
            ),
          );
        });
      } else {
        Timer(Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreenUser(),
            ),
          );
        });
      }
    } else {
      navigateToLoginScreen();
    }
  }

  Future<void> getValidationData() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final obtainedEmail = sharedPreferences.getString('email');
    final isAdmin = await validateAdminCredentials(obtainedEmail ?? ''); // Validate admin status
    setState(() {
      finalEmail = obtainedEmail;
      this.isAdmin = isAdmin;
    });
  }


  Future<bool> validateUserCredentials(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error validating user credentials: $e");
      return false;
    }
  }

  Future<bool> validateAdminCredentials(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance
          .collection('admin')
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error validating admin credentials: $e");
      return false;
    }
  }

  void navigateToLoginScreen() {
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    });
  }

  void navigateToLoginAdminScreen() {
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreenAdmin(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background1.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 50),
                Lottie.network(
                  'https://lottie.host/0ee62137-79d5-4042-b7ed-58ad98b7450d/75YOn1Ql73.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                  repeat: true,
                  reverse: true,
                  animate: true,
                ),
                SizedBox(height: 10),
                Text(
                  'version 2.1',
                  style: TextStyle(
                    fontSize: 14, // Adjust the font size as needed
                    color: Colors.black, // Adjust the color as needed
                    fontWeight: FontWeight.bold, // Add bold weight if desired
                    // You can add more style properties as needed
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

