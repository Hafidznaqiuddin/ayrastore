
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({Key? key}) : super(key: key);

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {

  final _emailController = TextEditingController();

  @override
  void dispose(){
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try{
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(context: context,
          builder: (context){
            return AlertDialog(content: Text('Password reset link sent ! Check your email'),
            );
          }
      );

    }on FirebaseAuthException catch (e){
      print(e);
      showDialog(context: context,
          builder: (context){
            return AlertDialog(content: Text(e.message.toString()),
            );
          }
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    var height  = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text('',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network('https://assets10.lottiefiles.com/packages/lf20_xvrofzfk.json',height: height * 0.20,
            repeat:  true,
            reverse: true,
            animate: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Enter Your Email and We will send you a password reset link',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),

          SizedBox(height: 10,),

          ///email textfield
          Padding(
            padding:const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1 ,color: Colors.blue),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.black,
                ),
                filled: true,
                fillColor: Colors.white,
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 10,),

          //button under textfield
          MaterialButton(
            onPressed: passwordReset,
            child: Text(
              'Reset Password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            color: Colors.deepPurple,
          )
        ],
      ),
    );
  }
}
