import 'package:ayrastore/Admin/Screen/CRUD/pdfreport.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Report extends StatefulWidget {
  @override
  State<Report> createState() => _ReportbalanceState();
}

class _ReportbalanceState extends State<Report> {
  var ww = 'Bag';

  var options1 = ['Bag', 'Wallet'];
  var _currentItemSelected1 = "Bag";
  var rool1 = "Wallet";

  var temp = [];
  var tt = [];

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('Item_list')
        .where('category', isEqualTo: ww)
        .snapshots();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigateToPdfReport(temp);
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            ),
            child: const Center(
              child: Icon(
                color: Colors.white,
                Icons.print,
                size: 20,
              ),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Report',
                style: Theme.of(context).textTheme.headline1!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "NexaRegular",
                  color: Get.isDarkMode
                      ? Colors.black
                      : const Color.fromRGBO(3, 3, 3, 1.0),
                ),
              ),
              SizedBox(width: 15),
              DropdownButton<String>(
                dropdownColor: Colors.white,
                isDense: true,
                isExpanded: false,
                iconEnabledColor: Colors.black,
                focusColor: Colors.black,
                items: options1.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(
                      dropDownStringItem,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newValueSelected1) {
                  setState(() {
                    _currentItemSelected1 = newValueSelected1!;
                    ww = '';
                    ww = _currentItemSelected1;
                  });
                  print(ww);
                },
                value: _currentItemSelected1,
              ),
            ],
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: _usersStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            // Clear temp list before populating
            temp.clear();
            // Populate temp list with data from Firestore
            snapshot.data!.docs.forEach((item) {
              final itemBrand = item['brand'];
              final itemModel = item['model'] ?? ''; // Handle null value
              final itemQuantity = item['quantity'] ?? 0; // Handle null value
              final itemDatebuy = item['datebuy'] ?? ''; // Handle null value
              final itemDatesell = item['datesell'] ?? ''; // Handle null value
              // Add data to temp list as a map
              temp.add({
                'brand': itemBrand,
                'model': itemModel,
                'quantity': itemQuantity,
                'datebuy': itemDatebuy,
                'datesell': itemDatesell,
                'isSelected': false, // Add isSelected field to track checkbox state
              });
            });
            // Return your UI with the updated data
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                itemCount: temp.length,
                itemBuilder: (_, index) {
                  final item = temp[index];
                  final itemBrand = item['brand'] ?? '';
                  final itemModel = item['model'] ?? '';
                  final itemQuantity = item['quantity'] ?? '';
                  final itemDatebuy = item['datebuy'] ?? '';
                  final itemDatesell = item['datesell'] ?? '';
                  bool isSelected = item['isSelected'] ?? false; // Retrieve checkbox state from map
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        title: Text(
                          itemBrand,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.add_box, size: 20),
                                  SizedBox(width: 8),
                                  Text('Model: $itemModel', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.inventory_2, size: 20),
                                  SizedBox(width: 8),
                                  Text('Available: $itemQuantity', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.date_range, size: 20),
                                  SizedBox(width: 8),
                                  Text('DateBuy: $itemDatebuy', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.date_range, size: 20),
                                  SizedBox(width: 8),
                                  Text('DateSell: $itemDatesell', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToPdfReport(List list) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => pdfReport(
          list: list,
          clas: ww,
          total: tt,
        ),
      ),
    );
  }
}
