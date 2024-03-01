// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../User/ModelUser.dart';
// import '../../User/ScreenUser/HomeScreenUser.dart';
// import 'LoginScreen/loginScreen.dart';
// import 'SignupScreen/SignupScreen.dart';
//
// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background image
//           Image.asset(
//             'assets/images/welcome.jpg', // Replace 'assets/background_image.jpg' with your image path
//             width: double.infinity,
//             height: double.infinity,
//             fit: BoxFit.cover,
//           ),
//           // Contents
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Column(
//                   children: [
//                     Text(
//                       '',
//                       style: GoogleFonts.arapey(
//                         textStyle: Theme.of(context).textTheme.displayLarge,
//                         fontSize: 40,
//                         fontWeight: FontWeight.bold,
//                         fontStyle: FontStyle.italic,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Text(
//                       '',
//                       style: GoogleFonts.arapey(
//                         textStyle: Theme.of(context).textTheme.displayLarge,
//                         fontSize: 40,
//                         fontWeight: FontWeight.bold,
//                         fontStyle: FontStyle.italic,
//                         color: Colors.deepPurple,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 70),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     OutlinedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => HomeScreenUser()),
//                         );
//                       },
//                       style: OutlinedButton.styleFrom(
//                         side: BorderSide(color: Colors.white),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
//                       ),
//                       child: Text(
//                         'Get Started',
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ),
//                     // SizedBox(width: 20),
//                     // OutlinedButton(
//                     //   onPressed: () {
//                     //     Navigator.push(
//                     //       context,
//                     //       MaterialPageRoute(builder: (context) => SignupScreen()),
//                     //     );
//                     //   },
//                     //   style: OutlinedButton.styleFrom(
//                     //     side: BorderSide(color: Colors.white),
//                     //     shape: RoundedRectangleBorder(
//                     //       borderRadius: BorderRadius.circular(30),
//                     //     ),
//                     //     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//                     //   ),
//                     //   child: Text(
//                     //     'Signup',
//                     //     style: TextStyle(fontSize: 16, color: Colors.white),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
