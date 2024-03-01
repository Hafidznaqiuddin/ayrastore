import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Model.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class UpdateScreen extends StatefulWidget {
  final DocumentSnapshot item;

  UpdateScreen({required this.item});

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late TextEditingController cateController;
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController nosiriController;
  late TextEditingController quantityController;
  late TextEditingController modelController;
  late TextEditingController detailController;
  late TextEditingController costController;
  late TextEditingController datebuyController;
  late TextEditingController datesellController;
  late TextEditingController _featureController; // Updated controller for features
  late List<String> imageUrls;
  //late List<String> features; // Updated list to store features
  final ImagePicker _picker = ImagePicker();
  bool isActive = true;
  late String selectedCategory;
  late String selectedBrand;
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(symbol: '');

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.item['category'] ?? "";
    selectedBrand = widget.item['brand'] ?? "";
    nosiriController = TextEditingController(text: widget.item['No Siri']);
    priceController = TextEditingController(text: widget.item['price']);
    quantityController = TextEditingController(text: widget.item['quantity']);
    modelController = TextEditingController(text: widget.item['model']);
    detailController = TextEditingController(text: widget.item['detail']);
    _featureController = TextEditingController(text: widget.item['dimensions']);
    costController = TextEditingController(text: widget.item['cost']);
    datebuyController = TextEditingController(text: widget.item['datebuy']);
    datesellController = TextEditingController(text: widget.item['datesell']);
    imageUrls = List<String>.from(widget.item['images'] ?? []);
    isActive = widget.item['active'] ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await _showDeleteConfirmationDialog();
            },
            icon: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

                    if (file == null) return;

                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages = referenceRoot.child('images');
                    Reference referenceImageToUpload =
                    referenceDirImages.child(DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');

                    await referenceImageToUpload.putFile(
                      File(file.path),
                      SettableMetadata(contentType: 'image/jpeg'),
                    );

                    String updatedImageUrl = await referenceImageToUpload.getDownloadURL();

                    setState(() {
                      imageUrls.add(updatedImageUrl); // Append the new image URL
                    });
                  } catch (error) {
                    print('Error uploading image: $error');
                  }
                },
                icon: Icon(Icons.camera_alt),
                label: Text('Upload Image'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.purpleAccent,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Display images
              if (imageUrls.isNotEmpty)
                Container(
                  height: 250,
                  width: double.infinity,
                  child: ReorderableListView(
                    scrollDirection: Axis.horizontal,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1; // Adjust newIndex if the item is moved downwards
                        }
                        final String item = imageUrls.removeAt(oldIndex);
                        imageUrls.insert(newIndex, item);
                      });
                    },
                    children: imageUrls.map((imageUrl) {
                      int index = imageUrls.indexOf(imageUrl);
                      return Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        key: Key('$index'), // Set a unique key for each item
                        child: Stack(
                          children: [
                            Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
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
                        ),
                      );
                    }).toList(),
                  ),
                ),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Category').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final categories = snapshot.data!.docs.reversed.toList();

                  return DropdownButtonFormField(
                    items: [
                      // Assuming the default value is not needed
                      for (var category in categories)
                        DropdownMenuItem(
                          value: category.id,
                          child: Text(category['category']),
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
                    onChanged: (categoryValue) {
                      setState(() {
                        selectedCategory = categoryValue.toString(); // Update the selected category
                      });
                    },
                    value: selectedCategory, // Set the initial value to the category from the document
                    isExpanded: false,
                  );
                },
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Brand').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final brands = snapshot.data!.docs.reversed.toList();

                  return DropdownButtonFormField(
                    items: [
                      // Assuming the default value is not needed
                      for (var brand in brands)
                        DropdownMenuItem(
                          value: brand.id,
                          child: Text(brand['Brand']),
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
                    onChanged: (brandValue) {
                      setState(() {
                        selectedBrand = brandValue.toString(); // Update the selected brand
                      });
                    },
                    value: selectedBrand, // Set the initial value to the brand from the document
                    isExpanded: false,
                  );
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: nosiriController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'No Siri',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [_formatter],
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: modelController,
                decoration: InputDecoration(
                  labelText: 'Model',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: detailController,
                decoration: InputDecoration(
                  labelText: 'Detail',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _featureController,
                decoration: InputDecoration(
                  labelText: 'Dimensions',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: costController,
                inputFormatters: [_formatter],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Cost',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: datebuyController,
                decoration: InputDecoration(
                  labelText: 'Date Buy',
                  border: OutlineInputBorder(),
                ),
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
                      datebuyController.text = formatDate;
                    });
                  }
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: datesellController,
                decoration: InputDecoration(
                  labelText: 'Date Sell',
                  border: OutlineInputBorder(),
                ),
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
                      datesellController.text = formatDate;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive = value!;
                      });
                    },
                  ),
                  Text('Active'),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance.collection('Item_list').doc(widget.item.id).update({
                        'category': selectedCategory,
                        'brand': selectedBrand,
                        'No Siri': nosiriController.text,
                        'price': priceController.text,
                        'quantity': quantityController.text,
                        'model': modelController.text,
                        'detail': detailController.text,
                        'dimensions' : _featureController.text,
                        'cost': costController.text,
                        'datebuy': datebuyController.text,
                        'datesell': datesellController.text,
                        'images': imageUrls,
                        'active': isActive,
                      });
                      print('Document updated successfully');
                      if (isActive) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ModelScreenManage()));
                      }
                    } catch (e) {
                      print('Error updating document: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pinkAccent,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void addFeature() {
  //   setState(() {
  //     if (_featureController.text.isNotEmpty) {
  //       features.add(_featureController.text);
  //       _featureController.clear();
  //     }
  //   });
  // }

  Future<void> deleteItem() async {
    try {
      await FirebaseFirestore.instance.collection('Item_list').doc(widget.item.id).delete();
      print('Document deleted successfully');
      Navigator.pop(context);
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are you sure?",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
              ),
              SizedBox(height: 10),
              Text("This action cannot be undone."),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await deleteItem(); // Perform deletion
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
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
