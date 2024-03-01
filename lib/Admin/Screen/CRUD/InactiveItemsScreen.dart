import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InactiveItemsScreen extends StatefulWidget {
  @override
  _InactiveItemsScreenState createState() => _InactiveItemsScreenState();
}

class _InactiveItemsScreenState extends State<InactiveItemsScreen> {
  String selectedbrand = 'All';
  String selectedcategory = 'All';

  List<String> categories = [];
  List<String> brands = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchBrands();
  }

  Future<void> fetchCategories() async {
    QuerySnapshot categorySnapshot =
    await FirebaseFirestore.instance.collection('Category').get();
    setState(() {
      categories = ['All'] +
          categorySnapshot.docs
              .map((doc) => doc['category'].toString())
              .toList();
    });
  }

  Future<void> fetchBrands() async {
    QuerySnapshot brandSnapshot =
    await FirebaseFirestore.instance.collection('Brand').get();
    setState(() {
      brands = ['All'] +
          brandSnapshot.docs.map((doc) => doc['Brand'].toString()).toList();
    });
  }

  Widget buildCategoryDropdown() {
    return Expanded(
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black38, width: 1),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedcategory,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedcategory = newValue;
                });
              }
            },
            items: categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }


  Widget buildBrandDropdown() {
    return Expanded(
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black38, width: 1),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedbrand,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedbrand = newValue;
                });
              }
            },
            items: brands.map((brand) {
              return DropdownMenuItem<String>(
                value: brand,
                child: Text(brand),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 8),
                Text(
                  'Category & Brand',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    buildCategoryDropdown(),
                    SizedBox(width: 8),
                    buildBrandDropdown(),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Item_list')
                  .where('active', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No inactive items found.'));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                var items = snapshot.data!.docs;

                var filteredItems = items.where((item) {
                  bool categoryMatches = selectedcategory == 'All' || item['category'] == selectedcategory;
                  bool brandMatches = selectedbrand == 'All' || item['brand'] == selectedbrand;

                  return categoryMatches && brandMatches ;
                }).toList();

                return ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    var item = filteredItems[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          title: Text(
                            item['category'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                'Brand: ${item['brand'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Model: ${item['model'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Date Buy: ${item['datebuy'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Date Sell: ${item['datesell'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          leading: _buildLeadingImage(item),
                          onTap: () async {
                            bool confirmed = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Are you sure?'),
                                content: Text(
                                    'Are you sure you want to activate this item?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text('Activate'),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed == true) {
                              await FirebaseFirestore.instance
                                  .collection('Item_list')
                                  .doc(item.id)
                                  .update({'active': true});
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadingImage(DocumentSnapshot item) {
    final List<dynamic>? images = item['images'];
    if (images != null && images.isNotEmpty && images[0] != null) {
      return Image.network(
        images[0],
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        width: 50,
        height: 50,
        color: Colors.grey.withOpacity(0.5),
        child: Icon(Icons.image),
      );
    }
  }
}
