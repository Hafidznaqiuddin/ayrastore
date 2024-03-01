import 'package:ayrastore/Admin/Screen/LoginScreen/loginScreenAdmin.dart';
import 'package:ayrastore/User/ScreenUser/sortScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Admin/Screen/CRUD/NotificationScreenUser.dart';
import '../../Admin/Screen/LoginScreen/loginScreen.dart';
import '../../User/ScreenUser/filterScreen.dart';
import 'CRUD/AddBrandScreen.dart';
import 'CRUD/AddCategoryScreen.dart';
import 'CRUD/InactiveItemsScreen.dart';
import 'CRUD/NotificationScreenAdmin.dart';
import 'CRUD/UpdateScreen.dart';
import 'CRUD/report.dart';
import 'CRUD/viewadmin.dart';
import 'CRUD/viewuser.dart';
import 'LoginScreen/SplashScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController searchController;
  late SharedPreferences logindata;
  late String currentSortOption;

  late bool newuser;
  String username = '';
  String selectedbrand = 'All';
  String selectedcategory = 'All';
  String minPrice = '';
  String maxPrice = '';

  List<String> price = [];
  List<String> categories = [];
  List<String> brands = [];
  final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

  Stream<QuerySnapshot> itemStream = FirebaseFirestore.instance.collection('Item_list').snapshots();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    initial();
    fetchCategories();
    fetchBrands();
    currentSortOption = ''; // Initialize with no sort option selected

    //fetchPrice();
    //check_if_already_login();
  }

  double? parseDouble(String value) {
    // Remove non-numeric characters from the value
    String cleanValue = value.replaceAll(RegExp(r'[^0-9.]'), '');

    // Parse the cleaned string to double
    try {
      return double.parse(cleanValue);
    } catch (e) {
      // Handle parsing errors here
      print('Error parsing double: $e');
      return null;
    }
  }


  // void check_if_already_login() async {
  //   SharedPreferences logindata = await SharedPreferences.getInstance();
  //   bool isLoggedIn = logindata.getBool('login') ?? true; // Assume user is not logged in by default
  //
  //   if (!isLoggedIn) {
  //     // If the user is not logged in, navigate to the login screen
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => LoginScreen()),
  //     );
  //   }
  // }


  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('email') ?? '';
    });
  }

  void logout() async {
    await logindata.setBool('login', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> fetchCategories() async {
    QuerySnapshot categorySnapshot =
    await FirebaseFirestore.instance.collection('Item_list').get();
    setState(() {
      categories = ['All'] +
          categorySnapshot.docs
              .map((doc) => doc['category'].toString())
              .toList();
      // Remove duplicates
      categories = categories.toSet().toList();
    });
  }

  Future<void> fetchBrands() async {
    QuerySnapshot brandSnapshot =
    await FirebaseFirestore.instance.collection('Item_list').get();
    setState(() {
      brands = ['All'] +
          brandSnapshot.docs.map((doc) => doc['brand'].toString()).toList();
      // Remove duplicates
      brands = brands.toSet().toList();
    });
  }


  // Future<void> fetchPrice() async {
  //   QuerySnapshot priceSnapshot =
  //   await FirebaseFirestore.instance.collection('money_info').get();
  //   setState(() {
  //     List<String> allRanges = [];
  //     for (QueryDocumentSnapshot doc in priceSnapshot.docs) {
  //       List<dynamic> ranges = doc['ranges'];
  //       for (var range in ranges) {
  //         allRanges.add('$range');
  //       }
  //     }
  //     price = ['All', ...allRanges];
  //   });
  // }

  bool searchByBrand(DocumentSnapshot item) {
    var brand = item['brand']?.toString().toLowerCase() ?? '';
    var category = item['category']?.toString().toLowerCase() ?? '';
    var price = item['price']?.toString().toLowerCase() ?? '';

    var query = searchController.text.toLowerCase();

    return brand.contains(query) ||
        category.contains(query) ||
        price.contains(query);
  }

  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true for adjustable height
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: FilterBottomSheet(
              categories: categories, // Pass your list of categories
              brands: brands, // Pass your list of brands
              selectedCategory: selectedcategory, // Pass selected category
              selectedBrand: selectedbrand, // Pass selected brand
              minPrice: minPrice, // Pass minPrice
              maxPrice: maxPrice, // Pass maxPrice
              onApplyFilter: applyFilter, // Pass your filter function
            ),
          ),
        );
      },
    );
  }

  void showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SortBottomSheet(
          onSort: _sortItems,
          currentSortOption: currentSortOption,
        );
      },
    );
  }

  void _sortItems(String sortOption) {
    setState(() {
      switch (sortOption) {
        case 'low_to_high':
        // Sort items by price from low to high
          currentSortOption = 'low_to_high';
          itemStream = FirebaseFirestore.instance.collection('Item_list').orderBy('price').snapshots();
          break;
        case 'high_to_low':
        // Sort items by price from high to low
          currentSortOption = 'high_to_low';
          itemStream = FirebaseFirestore.instance.collection('Item_list').orderBy('price', descending: true).snapshots();
          break;
        case 'clear_sorting':
        // Clear sorting, reset the currentSortOption and stream
          currentSortOption = ''; // Assign empty string instead of null
          itemStream = FirebaseFirestore.instance.collection('Item_list').snapshots();
          break;
        default:
        // Default case, do nothing or handle it as per your requirement
          break;
      }
    });
  }

  void applyFilter(String selectedCategory, String selectedBrand, String minPrice, String maxPrice) {
    setState(() {
      this.selectedcategory = selectedCategory;
      this.selectedbrand = selectedBrand;
      this.minPrice = minPrice;
      this.maxPrice = maxPrice;
    });
    Navigator.pop(context); // Close the bottom sheet
  }

  Widget buildSidebar() {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.pinkAccent,
                    size: 40,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '$username',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag_outlined),
            title: Text('Not Active'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => InactiveItemsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.add_box),
            title: Text('Add Category'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddCategoryScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.add_circle),
            title: Text('Add Brand'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddBrandScreen()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text('User Management'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ItemListManager()));
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('User List'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ItemListUser()));
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text('Report'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Report()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: Text(
              'Log Out',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onTap: () async {
              // Clear SharedPreferences
              final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              //await sharedPreferences.clear();

              // Navigate to LoginScreenAdmin and remove all previous routes
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget makeItem(DocumentSnapshot item, BuildContext context) {
    var itemName = item['brand'] ?? 'No Name';
    var itemModel = item['model'] ?? 'No Name';
    var itemPrice = item['price'] != null ? '${item['price']}' : 'Price not available';
    List<dynamic> images = item['images'] ?? [];

    if (images.isEmpty) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateScreen(item: item),
          ),
        );
      },
      child: Container(
        height: 365,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.network(
                images[0],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Item Information
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      itemModel,
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "RM $itemPrice",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 12),
                    // Additional item information can be added here
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async {
      // Exit the app when back button is pressed
      SystemNavigator.pop();
      return false; // Prevent default behavior
    },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimationSearchBar(
                searchBarWidth: 250,
                searchBarHeight: 40,
                isBackButtonVisible: false,
                hintText: 'Search',
                searchTextEditingController: searchController,
                onChanged: (query) {
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: IconButton(
                icon: Stack(
                  children: [
                    Icon(Icons.notifications),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('admin').doc(currentUserUid).collection('notification').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Return a loading indicator while fetching notifications
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          // Handle error
                          return SizedBox();
                        }

                        // Calculate the total number of notifications
                        final notificationCount = snapshot.data!.docs.length;

                        // Display a badge only if there are notifications
                        if (notificationCount > 0) {
                          return Positioned(
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4), // Adjust padding for desired size
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 5, // Adjust minimum width
                                minHeight: 5, // Adjust minimum height
                              ),
                              child: Text(
                                notificationCount > 9 ? '9+' : notificationCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 5, // Adjust font size if necessary
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => NotificationScreenAdmin()),
                  );
                },
              ),
            ),
          ],
        ),
        drawer: buildSidebar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      showFilterBottomSheet(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon and text for filtering
                          Icon(Icons.playlist_add, size: 22, color: Colors.grey.shade600), // Icon for filtering
                          SizedBox(width: 8), // Spacer
                          Text(
                            'Filter',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      showSortBottomSheet(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon and text for sorting
                          Icon(Icons.sort, size: 22, color: Colors.grey.shade600), // Icon for sorting
                          SizedBox(width: 8), // Spacer
                          Text(
                            'Sort',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: itemStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(color: Colors.pink));
                  }

                  var items = snapshot.data!.docs;

                  var filteredItems = items.where((item) {
                    bool brandMatches = selectedbrand == 'All' || item['brand'] == selectedbrand;
                    bool categoryMatches = selectedcategory == 'All' || item['category'] == selectedcategory;
                    bool isActive = item['active'] == null || item['active'] == true;

                    if (minPrice.isEmpty && maxPrice.isEmpty) {
                      return brandMatches && categoryMatches && isActive;
                    } else {
                      // Parse price values and handle parsing errors
                      try {
                        double itemPrice = double.parse(item['price'] ?? '0');
                        double minPriceValue = minPrice.isEmpty ? double.negativeInfinity : double.parse(minPrice);
                        double maxPriceValue = maxPrice.isEmpty ? double.infinity : double.parse(maxPrice);
                        return brandMatches && categoryMatches && itemPrice >= minPriceValue && itemPrice <= maxPriceValue && isActive;
                      } catch (e) {
                        print('Error parsing price: $e');
                        return false; // Skip items with invalid price values
                      }
                    }
                  }).toList();

                  String query = searchController.text.toLowerCase();
                  filteredItems = filteredItems.where((item) => searchByBrand(item)).toList();

                  // Sorting based on currentSortOption
                  switch (currentSortOption) {
                    case 'low_to_high':
                      filteredItems.sort((a, b) => (a['price'] ?? 0).compareTo(b['price'] ?? 0));
                      break;
                    case 'high_to_low':
                      filteredItems.sort((a, b) => (b['price'] ?? 0).compareTo(a['price'] ?? 0));
                      break;
                  }

                  List<List<DocumentSnapshot>> pairs = [];

                  for (int i = 0; i < filteredItems.length; i += 2) {
                    if (i + 1 < filteredItems.length) {
                      pairs.add([filteredItems[i], filteredItems[i + 1]]); // Changed from i + 2 to i + 1
                    }
                    else {
                      pairs.add([filteredItems[i]]);
                    }
                  }


                  return SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: pairs.map((pair) {
                        return Row(
                          children: [
                            Expanded(
                              child: makeItem(pair[0], context),
                            ),
                            SizedBox(width: 16),
                            if (pair.length == 2)
                              Expanded(
                                child: makeItem(pair[1], context),
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
