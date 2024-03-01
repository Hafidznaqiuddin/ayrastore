// import 'package:ayrastore/Admin/Screen/CRUD/InactiveWalletScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:animation_search_bar/animation_search_bar.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'CRUD/InactiveItemsScreen.dart';
// import 'CRUD/UpdateScreen.dart';
// import 'CRUD/UpdateWalletScreen.dart';
// import 'LoginScreen/loginScreen.dart';
// import 'WelcomeScreen.dart';
//
// class HomeWalletScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeWalletScreen> {
//   late TextEditingController searchController;
//   late SharedPreferences logindata;
//   late bool newuser;
//   String username = '';
//
//   @override
//   void initState() {
//     super.initState();
//     searchController = TextEditingController();
//     initial();
//   }
//
//   void initial() async {
//     logindata = await SharedPreferences.getInstance();
//     setState(() {
//       username = logindata.getString('email') ?? '';
//     });
//   }
//
//   void logout() async {
//     await logindata.setBool('login', true);
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => WelcomeScreen()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         actions: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: AnimationSearchBar(
//               searchBarWidth: 280,
//               searchBarHeight: 40,
//               isBackButtonVisible: false,
//               hintText: 'Search by Name',
//               searchTextEditingController: searchController,
//               onChanged: (query) {
//                 setState(() {});
//               },
//             ),
//           ),
//         ],
//       ),
//       drawer: buildSidebar(),
//       backgroundColor: Colors.white,
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('wallet_list').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator(color: Colors.pink));
//           }
//
//           var items = snapshot.data!.docs;
//
//           var filteredItems = items.where((item) {
//             var itemName = item['brand'].toString().toLowerCase();
//             var query = searchController.text.toLowerCase();
//             return itemName.contains(query) && (item['active'] == null || item['active'] == true);
//           }).toList();
//
//           List<List<DocumentSnapshot>> pairs = [];
//           for (int i = 0; i < filteredItems.length; i += 2) {
//             if (i + 1 < filteredItems.length) {
//               pairs.add([filteredItems[i], filteredItems[i + 1]]);
//             } else {
//               pairs.add([filteredItems[i]]);
//             }
//           }
//
//           return SingleChildScrollView(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: pairs.map((pair) {
//                 return Row(
//                   children: [
//                     Expanded(
//                       child: makeItem(pair[0], context),
//                     ),
//                     SizedBox(width: 16),
//                     if (pair.length == 2)
//                       Expanded(
//                         child: makeItem(pair[1], context),
//                       ),
//                   ],
//                 );
//               }).toList(),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget buildSidebar() {
//     return Drawer(
//       backgroundColor: Colors.white,
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.deepPurple,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: Colors.white,
//                   child: Icon(
//                     Icons.favorite,
//                     color: Colors.pinkAccent,
//                     size: 40,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   '$username',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.shopping_bag_outlined),
//             title: Text('Active Bag'),
//             onTap: () {
//               Navigator.of(context).push(MaterialPageRoute(builder: (context) => InactiveItemsScreen()));
//             },
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.receipt),
//             title: Text('Report'),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.account_circle),
//             title: Text('Login Account'),
//             onTap: () {
//               logout();
//             },
//           ),
//           ListTile(
//             leading: Icon(
//               Icons.exit_to_app,
//               color: Colors.red,
//             ),
//             title: Text(
//               'Log Out',
//               style: TextStyle(
//                 color: Colors.red,
//               ),
//             ),
//             onTap: () {
//               logout();
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget makeItem(DocumentSnapshot item, BuildContext context) {
//     var itemName = item['brand'] ?? 'No Name';
//     List<dynamic> images = item['images'] ?? [];
//
//     if (images.isEmpty) {
//       return Container();
//     }
//
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => UpdateWalletScreen(item: item),
//           ),
//         );
//       },
//       child: Container(
//         height: 230,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         margin: EdgeInsets.only(bottom: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20),
//                 ),
//                 child: Stack(
//                   children: [
//                     Positioned.fill(
//                       child: Image.network(
//                         images[0],
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       left: 0,
//                       right: 0,
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           vertical: 10,
//                           horizontal: 20,
//                         ),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.bottomCenter,
//                             end: Alignment.topCenter,
//                             colors: [
//                               Colors.black.withOpacity(0.7),
//                               Colors.transparent,
//                             ],
//                           ),
//                         ),
//                         child: Text(
//                           itemName,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
