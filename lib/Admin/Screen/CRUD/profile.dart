// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart%20';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';
//
// import '../../../User/ScreenUser/HomeScreenUser.dart';
//
// class ProfileScreen extends StatefulWidget {
//   @override
//   State <ProfileScreen> createState() => _InsertManagerState();
// }
//
// class _InsertManagerState extends State<ProfileScreen> {
//   TextEditingController passwordController =  new TextEditingController();
//   TextEditingController confirmpassController = new TextEditingController();
//   TextEditingController fullNameController = new TextEditingController();
//   TextEditingController emailController = new TextEditingController();
//   TextEditingController mobileController =  new TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   @override
//   void dispose(){
//     passwordController.dispose();
//     confirmpassController.dispose();
//     fullNameController.dispose();
//     emailController.dispose();
//     mobileController.dispose();
//     super.dispose();
//   }
//
//   bool showProgress = false;
//   bool visible = false;
//
//   GlobalKey<FormState> key = GlobalKey();
//
//   bool _isObscure = true;
//   bool _isObscure2 = true;
//   File? file;
//   var options = [
//     'Admin',
//   ];
//   var _currentItemSelected = "Admin";
//   var rool = "Admin";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title:  Text('',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 25,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left, color: Colors.black,),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Container(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//               child: SingleChildScrollView(
//                 child: Container(
//                   margin: EdgeInsets.all(12),
//                   child: Form(
//                     key: key,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           height: 40,
//                         ),
//                         TextFormField(
//                           controller: fullNameController,
//                           decoration: InputDecoration(
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.blue.shade800),
//                               borderRadius: BorderRadius.circular(5.5),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Colors.blue.shade800,
//                               ),
//                             ),
//                             prefixIcon: Icon(
//                               Icons.account_circle_outlined,
//                               color: Colors.blue.shade800,
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                             labelText: "Full Name",
//                             labelStyle: TextStyle(color: Colors.blue),
//                           ),
//                           validator: (String? value) {
//                             if (value == null || value.isEmpty) {
//                               return "Name cannot be empty";
//                             }
//                             return null;
//                           },
//                           onChanged: (value) {},
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         TextFormField(
//                           controller: emailController,
//                           decoration: InputDecoration(
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.blue.shade800),
//                               borderRadius: BorderRadius.circular(5.5),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Colors.blue.shade800,
//                               ),
//                             ),
//                             prefixIcon: Icon(
//                               Icons.email,
//                               color: Colors.blue.shade800,
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                             labelText: "E-Mail",
//                             labelStyle: TextStyle(color: Colors.blue),
//                           ),
//                           validator: (value) {
//                             if (value!.length == 0) {
//                               return "Email cannot be empty";
//                             }
//                             if (!RegExp(
//                                 "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
//                                 .hasMatch(value)) {
//                               return ("Please enter a valid email");
//                             } else {
//                               return null;
//                             }
//                           },
//                           onChanged: (value) {},
//                           keyboardType: TextInputType.emailAddress,
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         TextFormField(
//                           controller: mobileController,
//                           decoration: InputDecoration(
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.blue.shade800),
//                               borderRadius: BorderRadius.circular(5.5),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Colors.blue.shade800,
//                               ),
//                             ),
//                             prefixIcon: Icon(
//                               Icons.call,
//                               color: Colors.blue.shade800,
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                             labelText: "Mobile Number",
//                             labelStyle: TextStyle(color: Colors.blue),
//                           ),
//                           validator: (value) {
//                             if (value!.length == 0) {
//                               return "Number cannot be empty";
//                             } else {
//                               return null;
//                             }
//                           },
//                           onChanged: (value) {},
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         TextFormField(
//                           obscureText: _isObscure,
//                           controller: passwordController,
//                           decoration: InputDecoration(
//                             suffixIcon: IconButton(
//                                 icon: Icon(_isObscure
//                                     ? Icons.visibility_off
//                                     : Icons.visibility),
//                                 onPressed: () {
//                                   setState(() {
//                                     _isObscure = !_isObscure;
//                                   });
//                                 }),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.blue.shade800),
//                               borderRadius: BorderRadius.circular(5.5),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Colors.blue.shade800,
//                               ),
//                             ),
//                             prefixIcon: Icon(
//                               Icons.fingerprint,
//                               color: Colors.blue.shade800,
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                             labelText: "Password",
//                             labelStyle: TextStyle(color: Colors.blue),
//                           ),
//                           validator: (value) {
//                             RegExp regex = new RegExp(r'^.{6,}$');
//                             if (value!.isEmpty) {
//                               return "Password cannot be empty";
//                             }
//                             if (!regex.hasMatch(value)) {
//                               return ("please enter valid password min. 6 character");
//                             } else {
//                               return null;
//                             }
//                           },
//                           onChanged: (value) {},
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         TextFormField(
//                           obscureText: _isObscure2,
//                           controller: confirmpassController,
//                           decoration: InputDecoration(
//                             suffixIcon: IconButton(
//                                 icon: Icon(_isObscure2
//                                     ? Icons.visibility_off
//                                     : Icons.visibility),
//                                 onPressed: () {
//                                   setState(() {
//                                     _isObscure2 = !_isObscure2;
//                                   });
//                                 }),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.blue.shade800),
//                               borderRadius: BorderRadius.circular(5.5),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Colors.blue.shade800,
//                               ),
//                             ),
//                             prefixIcon: Icon(
//                               Icons.add_box_outlined,
//                               color: Colors.blue.shade800,
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                             labelText: "Confirm Password",
//                             labelStyle: TextStyle(color: Colors.blue),
//                           ),
//                           validator: (value) {
//                             if (confirmpassController.text !=
//                                 passwordController.text) {
//                               return "Password did not match";
//                             } else {
//                               return null;
//                             }
//                           },
//                           onChanged: (value) {},
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "New Manager : ",
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             DropdownButton<String>(
//                               dropdownColor: Colors.white,
//                               isDense: true,
//                               isExpanded: false,
//                               iconEnabledColor: Colors.white,
//                               focusColor: Colors.white,
//                               items: options.map((String dropDownStringItem) {
//                                 return DropdownMenuItem<String>(
//                                   value: dropDownStringItem,
//                                   child: Text(
//                                     dropDownStringItem,
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                               onChanged: (newValueSelected) {
//                                 setState(() {
//                                   _currentItemSelected = newValueSelected!;
//                                   //rool = newValueSelected;
//                                 });
//                               },
//                               value: _currentItemSelected,
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         SizedBox(
//                           height: 60.00,
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                                 primary: Colors.blue.shade900,
//                                 foregroundColor: Colors.white,
//                                 padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                                 textStyle: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 15,
//                                 )
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 showProgress = true;
//                               });
//                               signUp(emailController.text, passwordController.text, fullNameController.text, mobileController.text, _currentItemSelected);
//                             },
//                             child: Text('Add User'.toUpperCase()),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void signUp(String email, String password, String name, String number, String rool) async {
//     CircularProgressIndicator();
//     if (key.currentState!.validate()) {
//       await _auth
//           .createUserWithEmailAndPassword(email: email, password: password)
//           .then((value) => {postDetailsToFirestore(email, password, name, number,rool)})
//           .catchError((e) {});
//     }
//   }
//
//   postDetailsToFirestore(String email, String password, String name, String number, String rool) async {
//     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//     var user = _auth.currentUser;
//     CollectionReference ref = FirebaseFirestore.instance.collection('admin');
//     ref.doc(user!.uid).set({
//       'email': emailController.text,
//       'password': passwordController.text,
//       'Full Name': fullNameController.text,
//       'Number phone': mobileController.text,
//       'role': rool});
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => HomeScreenUser()));
//   }
// }