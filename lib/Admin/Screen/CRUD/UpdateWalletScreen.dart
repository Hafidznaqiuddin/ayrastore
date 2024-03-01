// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:animation_search_bar/animation_search_bar.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'CRUD/AddBrandScreen.dart';
// import 'CRUD/AddCategoryScreen.dart';
// import 'CRUD/InactiveItemsScreen.dart';
// import 'CRUD/NotificationScreenAdmin.dart';
// import 'CRUD/UpdateScreen.dart';
// import 'CRUD/report.dart';
// import '../../User/ScreenUser/HomeScreenUser.dart';
// import 'CRUD/viewadmin.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import 'LoginScreen/loginScreen.dart';
//
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   late TextEditingController searchController;
//   late SharedPreferences logindata;
//   late bool newuser;
//   String username = '';
//   String selectedbrand = 'All';
//   String selectedcategory = 'All';
//   String selectedPrice = 'All';
//
//   List<String> price = [];
//   List<String> categories = [];
//   List<String> brands = [];
//   final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
//
//   @override
//   void initState() {
//     super.initState();
//     searchController = TextEditingController();
//     initial();
//     fetchCategories();
//     fetchBrands();
//     fetchPrice();
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
//       MaterialPageRoute(builder: (context) => LoginScreen()),
//     );
//   }
//
//   Future<void> fetchCategories() async {
//     QuerySnapshot categorySnapshot =
//     await FirebaseFirestore.instance.collection('Category').get();
//     setState(() {
//       categories = ['All'] +
//           categorySnapshot.docs
//               .map((doc) => doc['category'].toString())
//               .toList();
//     });
//   }
//
//   Future<void> fetchBrands() async {
//     QuerySnapshot brandSnapshot =
//     await FirebaseFirestore.instance.collection('Brand').get();
//     setState(() {
//       brands = ['All'] +
//           brandSnapshot.docs.map((doc) => doc['Brand'].toString()).toList();
//     });
//   }
//
//   Future<void> fetchPrice() async {
//     QuerySnapshot priceSnapshot =
//     await FirebaseFirestore.instance.collection('money_info').get();
//     setState(() {
//       List<String> allRanges = [];
//       for (QueryDocumentSnapshot doc in priceSnapshot.docs) {
//         List<dynamic> ranges = doc['ranges'];
//         for (var range in ranges) {
//           allRanges.add('$range');
//         }
//       }
//       price = ['All', ...allRanges];
//     });
//   }
//
//   bool searchByBrand(DocumentSnapshot item) {
//     var brand = item['brand']?.toString().toLowerCase() ?? '';
//     var category = item['category']?.toString().toLowerCase() ?? '';
//     var price = item['price']?.toString().toLowerCase() ?? '';
//
//     var query = searchController.text.toLowerCase();
//
//     return brand.contains(query) || category.contains(query) || price.contains(query);
//   }
//
//   void showUploadNotification() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Item uploaded successfully!'),
//       ),
//     );
//
//     // Trigger rebuild of the ListView to include the new item
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         actions: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(1.0),
//             child: AnimationSearchBar(
//               searchBarWidth: 250,
//               searchBarHeight: 40,
//               isBackButtonVisible: false,
//               hintText: 'Search',
//               searchTextEditingController: searchController,
//               onChanged: (query) {
//                 setState(() {});
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(3.0),
//             child: IconButton(
//               icon: Stack(
//                 children: [
//                   Icon(Icons.notifications),
//                   StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance.collection('admin').doc(currentUserUid).collection('notification').snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         // Return a loading indicator while fetching notifications
//                         return CircularProgressIndicator();
//                       }
//                       if (snapshot.hasError) {
//                         // Handle error
//                         return SizedBox();
//                       }
//
//                       // Calculate the total number of notifications
//                       final notificationCount = snapshot.data!.docs.length;
//
//                       // Display a badge only if there are notifications
//                       if (notificationCount > 0) {
//                         return Positioned(
//                           right: 0,
//                           child: Container(
//                             padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4), // Adjust padding for desired size
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             constraints: BoxConstraints(
//                               minWidth: 5, // Adjust minimum width
//                               minHeight: 5, // Adjust minimum height
//                             ),
//                             child: Text(
//                               notificationCount > 9 ? '9+' : notificationCount.toString(),
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 5, // Adjust font size if necessary
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         );
//                       } else {
//                         return SizedBox();
//                       }
//                     },
//                   ),
//                 ],
//               ),
//               onPressed: () {
//                 // Handle notification button press
//                 Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => NotificationScreenAdmin()),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       drawer: buildSidebar(),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(height: 8),
//                 Text(
//                   'Category & Brand', // Text above Filter Option dropdown
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ), // Add some space between dropdowns
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         height: 35,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                           border:
//                           Border.all(color: Colors.black38, width: 1),
//                         ),
//                         padding: EdgeInsets.symmetric(horizontal: 12),
//                         child: DropdownButtonHideUnderline(
//                           child: DropdownButton<String>(
//                             value: selectedcategory,
//                             icon: Icon(Icons.arrow_drop_down),
//                             iconSize: 24,
//                             elevation: 16,
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 16,
//                             ),
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 selectedcategory = newValue ?? 'All';
//                               });
//                             },
//                             items: categories.map((category) {
//                               return DropdownMenuItem<String>(
//                                 value: category,
//                                 child: Text(category),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 8), // Add some space between dropdowns
//                     Expanded(
//                       child: Container(
//                         height: 35,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                           border:
//                           Border.all(color: Colors.black38, width: 1),
//                         ),
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         child: DropdownButtonHideUnderline(
//                           child: DropdownButton<String>(
//                             value: selectedbrand,
//                             icon: Icon(Icons.arrow_drop_down),
//                             iconSize: 24,
//                             elevation: 16,
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 16,
//                             ),
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 selectedbrand = newValue ?? 'All';
//                               });
//                             },
//                             items: brands.map((brand) {
//                               return DropdownMenuItem<String>(
//                                 value: brand,
//                                 child: Text(brand),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(width: 10),
//                 Text(
//                   'Price', // Text above Filter Option dropdown
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ), // Add some space between dropdowns
//                 Container(
//                   height: 35,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     border:
//                     Border.all(color: Colors.black38, width: 1),
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 12),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: selectedPrice,
//                       icon: Icon(Icons.arrow_drop_down),
//                       iconSize: 24,
//                       elevation: 16,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                       ),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedPrice = newValue ?? 'All';
//                         });
//                       },
//                       items: price.map((range) {
//                         return DropdownMenuItem<String>(
//                           value: range,
//                           child: Text(range),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance.collection('Item_list').snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return Center(child: CircularProgressIndicator(color: Colors.pink));
//                   }
//
//                   var items = snapshot.data!.docs;
//
//                   var filteredItems = items.where((item) {
//                     bool brandMatches = selectedbrand == 'All' || item['brand'] == selectedbrand;
//                     bool categoryMatches = selectedcategory == 'All' || item['category'] == selectedcategory;
//                     bool isActive = item['active'] == null || item['active'] == true;
//
//                     if (selectedPrice == 'All') {
//                       return brandMatches && categoryMatches && isActive;
//                     } else {
//                       // Extract the minimum and maximum prices from the selectedPrice
//                       List<String> priceParts = selectedPrice.split(' - ');
//                       if (priceParts.length == 2) {
//                         // Parse the prices
//                         double minPrice = double.tryParse(priceParts[0]) ?? 0.0;
//                         double maxPrice = double.tryParse(priceParts[1]) ?? 0.0;
//                         // Parse the item price from the database
//                         String itemPriceString = item['price'] ?? '0';
//                         double itemPrice = double.tryParse(itemPriceString) ?? 0.0;
//                         // Check if the item price falls within the selected range
//                         return brandMatches && categoryMatches && itemPrice >= minPrice && itemPrice <= maxPrice && isActive;
//                       } else {
//                         // Invalid price range format
//                         return false;
//                       }
//                     }
//                   }).toList();
//
//                   String query = searchController.text.toLowerCase();
//                   filteredItems = filteredItems.where((item) => searchByBrand(item)).toList();
//                   filteredItems.sort((a, b) => (a['brand'] ?? '').compareTo(b['brand'] ?? ''));
//
//                   List<List<DocumentSnapshot>> pairs = [];
//                   for (int i = 0; i < filteredItems.length; i += 2) {
//                     if (i + 1 < filteredItems.length) {
//                       pairs.add([filteredItems[i], filteredItems[i + 1]]);
//                     } else {
//                       pairs.add([filteredItems[i]]);
//                     }
//                   }
//
//                   return SingleChildScrollView(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                       children: pairs.map((pair) {
//                         return Row(
//                           children: [
//                             Expanded(
//                               child: makeItem(pair[0], context),
//                             ),
//                             SizedBox(width: 16),
//                             if (pair.length == 2)
//                               Expanded(
//                                 child: makeItem(pair[1], context),
//                               ),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   );
//                 },
//               )),
//         ],
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
//             title: Text('Active'),
//             onTap: () {
//               Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => InactiveItemsScreen()));
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.add_box),
//             title: Text('Add Category'),
//             onTap: () {
//               Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => AddCategoryScreen()));
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.add_circle),
//             title: Text('Add Brand'),
//             onTap: () {
//               Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => AddBrandScreen()));
//             },
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.account_circle_outlined),
//             title: Text('User Management'),
//             onTap: () {
//               Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => ItemListManager()));
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.receipt),
//             title: Text('Report'),
//             onTap: () {
//               Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => Report()));
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
//     var itemModel = item['model'] ?? 'No Name';
//     var itemPrice = item['price'] != null ? '${item['price']}' : 'Price not available';
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
//             builder: (context) => UpdateScreen(item: item),
//           ),
//         );
//       },
//       child: Container(
//         height: 265,
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
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Image
//             ClipRRect(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//               child: Image.network(
//                 images[0],
//                 height: 150,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             // Item Information
//             Expanded(
//               child: Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(20),
//                     bottomRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       itemName,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       itemModel,
//                       style: TextStyle(
//                         fontSize: 11,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       "RM $itemPrice",
//                       style: TextStyle(
//                         fontSize: 15,
//                         color: Colors.deepPurple,
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     // Additional item information can be added here
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
