import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import 'AddBrandScreen.dart';

class UploadBagScreen extends StatefulWidget {
  const UploadBagScreen({Key? key}) : super(key: key);

  @override
  _UploadBagScreenState createState() => _UploadBagScreenState();
}

class _UploadBagScreenState extends State<UploadBagScreen> {
  final _formKey = GlobalKey<FormState>();
  final _NoSiriController = TextEditingController();
  final _modelController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _detailController = TextEditingController();
  final _costController = TextEditingController();
  final _datebuyController = TextEditingController();
  final _datesellController = TextEditingController();
  final _featureController = TextEditingController();
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(symbol: '');

  int counter = 0;
  bool checkBoxValue = false;
  bool _isRefreshing = false;
  ScrollController _scrollController = ScrollController();

  // File upload variables
  String imageUrl = '';
  String selectedbrand = "0";
  String selectedcategory = "0";
  bool isUploading = false;
  List<String> imageUrls = [];
  List<String> features = []; // Added list to store features

  @override
  void initState() {
    _datesellController.text = "";
    _datebuyController.text = "";
    super.initState();
  }

  @override
  void dispose() {
    // Dispose controllers and scroll controller
    _NoSiriController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _detailController.dispose();
    _costController.dispose();
    _datebuyController.dispose();
    _datesellController.dispose();
    super.dispose();
    _scrollController.dispose();
  }
  void addFeature() {
    setState(() {
      if (_featureController.text.isNotEmpty) {
        features.add(_featureController.text);
        _featureController.clear();
      }
    });
  }


  void _onScroll() {
    // Implement onScroll logic if needed
  }

  Future<void> _refreshData() async {
    // Implement refresh data logic if needed
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Upload',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot>(
                      stream:
                      FirebaseFirestore.instance.collection('Category').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        final clients = snapshot.data?.docs.reversed.toList();
                        return DropdownButtonFormField(
                          items: [
                            DropdownMenuItem(
                              value: "0",
                              child: Text('Select Category'),
                            ),
                            for (var client in clients!)
                              DropdownMenuItem(
                                value: client.id,
                                child: Text(client['category']),
                              ),
                          ],
                          decoration: inputDecoration(
                            labelText: 'Select Category',
                          ),
                          iconEnabledColor: Colors.black,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          dropdownColor: Colors.white,
                          onChanged: (clientValue) {
                            setState(() {
                              selectedcategory = clientValue!;
                            });
                          },
                          value: selectedcategory,
                          isExpanded: false,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot>(
                      stream:
                      FirebaseFirestore.instance.collection('Brand').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        final clients = snapshot.data?.docs.reversed.toList();
                        return DropdownButtonFormField(
                          items: [
                            DropdownMenuItem(
                              value: "0",
                              child: Text('Select Brand'),
                            ),
                            for (var client in clients!)
                              DropdownMenuItem(
                                value: client.id,
                                child: Text(client['Brand']),
                              ),
                          ],
                          decoration: inputDecoration(
                            labelText: 'Select Brand',
                          ),
                          iconEnabledColor: Colors.black,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          dropdownColor: Colors.white,
                          onChanged: (clientValue) {
                            setState(() {
                              selectedbrand = clientValue!;
                            });
                          },
                          value: selectedbrand,
                          isExpanded: false,
                        );
                      },
                    ),
                    SizedBox(height:10),
                    TextFormField(
                      controller: _NoSiriController,
                      keyboardType: TextInputType.text,
                      decoration: inputDecoration(
                        hintText: '',
                        labelText: 'No Siri',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill this field';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height:10),
                    TextFormField(
                      controller: _modelController,
                      keyboardType: TextInputType.text,
                      decoration: inputDecoration(
                        hintText: '',
                        labelText: 'Model',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill this field';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [_formatter],
                      decoration: inputDecoration(
                        hintText: '',
                        labelText: 'Price Sell',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill this field';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _priceController.text = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _quantityController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: inputDecoration(
                        hintText: '',
                        labelText: 'Quantity',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill this quantity';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _detailController,
                      decoration: inputDecoration(
                        labelText: 'Detail',
                      ),
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill this field';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _featureController,
                      decoration: inputDecoration(
                        labelText: 'Dimensions',
                      ),
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill this field';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _costController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [_formatter],
                      decoration: inputDecoration(
                        hintText: '',
                        labelText: 'Cost Price',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill this field';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _datebuyController,
                      decoration: inputDecoration(
                        labelText: 'Date Buy',
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2200),
                        );
                        if (pickedDate != null) {
                          String formatDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                          setState(() {
                            _datebuyController.text = formatDate;
                          });
                        } else {
                          _datebuyController.text = "";
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _datesellController,
                      decoration: inputDecoration(
                        labelText: 'Date Sell',
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2200),
                        );
                        if (pickedDate != null) {
                          String formatDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                          setState(() {
                            _datesellController.text = formatDate;
                          });
                        } else {
                          _datesellController.text = "";
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: checkBoxValue,
                          onChanged: (value) {
                            setState(() {
                              checkBoxValue = value!;
                            });
                          },
                        ),
                        Text("Active"),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (!isUploading) {
                          ImagePicker imagePicker = ImagePicker();
                          List<XFile>? files = await imagePicker.pickMultiImage();

                          if (files == null || files.isEmpty) return;

                          try {
                            setState(() {
                              isUploading = true;
                            });

                            for (XFile file in files) {
                              Reference referenceRoot = FirebaseStorage.instance.ref();
                              Reference referenceDirImages = referenceRoot.child('images');
                              Reference referenceImageToUpload =
                              referenceDirImages.child(DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');

                              await referenceImageToUpload.putFile(
                                File(file.path),
                                SettableMetadata(contentType: 'image/jpeg'),
                              );

                              String imageUrl = await referenceImageToUpload.getDownloadURL();
                              imageUrls.add(imageUrl);
                            }
                          } catch (error) {
                            print('Error uploading image: $error');
                          } finally {
                            setState(() {
                              isUploading = false;
                            });
                          }
                        }
                      },
                      icon: Icon(Icons.camera_alt),
                      label: isUploading ? CircularProgressIndicator() : Text('Upload Images'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purpleAccent,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  imageUrls[index],
                                  height: 100,
                                  width: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 2,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    // Handle delete image action
                                    setState(() {
                                      imageUrls.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() && !isUploading) {
                          String itemSiri = _NoSiriController.text;
                          String itemModel = _modelController.text;
                          String itemPrice = _priceController.text;
                          String itemQuantity = _quantityController.text;
                          String itemDetail = _detailController.text;
                          String itemDimensions = _featureController.text;
                          String itemCost = _costController.text;
                          String itemDatebuy = _datebuyController.text;
                          String itemDatesell = _datesellController.text;

                          if (imageUrls.isNotEmpty) {
                            setState(() {
                              isUploading = true;
                            });

                            // Create a map to hold the bag details along with the notification details
                            Map<String, dynamic> dataToSend = {
                              'category': selectedcategory,
                              'brand': selectedbrand,
                              'No Siri': itemSiri,
                              'model': itemModel,
                              'price': itemPrice,
                              'quantity': itemQuantity,
                              'detail': itemDetail,
                              'dimensions': itemDimensions,
                              'cost': itemCost,
                              'datebuy': itemDatebuy,
                              'datesell': itemDatesell,
                              'active': checkBoxValue,
                              'images': imageUrls,
                            };

                            // Save data to Firestore 'Item_list' collection
                            await FirebaseFirestore.instance.collection('Item_list').add(dataToSend);

                            // Iterate through 'admin' collection to add notification for each admin
                            await FirebaseFirestore.instance.collection('admin').get().then((querySnapshot) {
                              querySnapshot.docs.forEach((userDoc) async {
                                await userDoc.reference.collection('notification').add({
                                  'category': selectedcategory,
                                  'brand': selectedbrand,
                                  'No Siri': itemSiri,
                                  'model': itemModel,
                                  'price': itemPrice,
                                  'quantity': itemQuantity,
                                  'detail': itemDetail,
                                  'dimensions': itemDimensions,
                                  'cost': itemCost,
                                  'datebuy': itemDatebuy,
                                  'datesell': itemDatesell,
                                  'active': checkBoxValue,
                                  'images': imageUrls,
                                  // Add more notification details if needed
                                });
                              });
                            });

                            await FirebaseFirestore.instance.collection('user').get().then((querySnapshot) {
                              querySnapshot.docs.forEach((userDoc) async {
                                await userDoc.reference.collection('notification').add({
                                  'category': selectedcategory,
                                  'brand': selectedbrand,
                                  'No Siri': itemSiri,
                                  'model': itemModel,
                                  'price': itemPrice,
                                  'quantity': itemQuantity,
                                  'detail': itemDetail,
                                  'dimensions': itemDimensions,
                                  'cost': itemCost,
                                  'datebuy': itemDatebuy,
                                  'datesell': itemDatesell,
                                  'active': checkBoxValue,
                                  'images': imageUrls,
                                  // Add more notification details if needed
                                });
                              });
                            });

                            // Clear form fields and imageUrls list
                            _NoSiriController.clear();
                            _modelController.clear();
                            _priceController.clear();
                            _quantityController.clear();
                            _featureController.clear();
                            _detailController.clear();
                            _costController.clear();
                            _datebuyController.clear();
                            _datesellController.clear();
                            setState(() {
                              imageUrls.clear();
                              features.clear();
                              isUploading = false;
                            });

                            // Optionally show a success dialog
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Form submitted successfully!'),
                              ),
                            );
                          } else {
                            // Handle the case where imageUrls list is empty
                            print('Please upload images before submitting.');
                            setState(() {
                              isUploading = false;
                            });
                          }
                        }
                      },
                      child: Text('Submit'),
                    ),

                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration({
    String? hintText,
    String? labelText,
    IconData? prefixIcon,
  }) =>
      InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(5.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.black) : null,
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        hintText: hintText,
      );

}
class MyNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else {
      final double amount = double.parse(newValue.text);
      final formattedValue = amount.toStringAsFixed(2); // Format to 2 decimal places
      return TextEditingValue(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length),
      );
    }
  }
}

