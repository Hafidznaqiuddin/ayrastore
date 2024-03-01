// import 'package:ayrastore/Admin/Screen/CRUD/AddWalletBrandScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:io';
// import 'package:intl/intl.dart';
//
// import 'AddBrandScreen.dart';
//
// class UploadWalletScreen extends StatefulWidget {
//   const UploadWalletScreen({Key? key}) : super(key: key);
//
//   @override
//   _UploadWalletScreenState createState() => _UploadWalletScreenState();
// }
//
// class _UploadWalletScreenState extends State<UploadWalletScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _brandController = TextEditingController();
//   final _modelController = TextEditingController();
//   final _priceController = TextEditingController();
//   final _quantityController = TextEditingController();
//   final _detailController = TextEditingController();
//   final _costController = TextEditingController();
//   final _datebuyController = TextEditingController();
//   final _datesellController = TextEditingController();
//   final _featureController = TextEditingController();
//
//   int counter = 0;
//   bool checkBoxValue = false;
//   bool _isRefreshing = false;
//   ScrollController _scrollController = ScrollController();
//
//   // File upload variables
//   String imageUrl = '';
//   String selectedcategory = "0";
//   bool isUploading = false;
//   List<String> imageUrls = [];
//   List<String> features = []; // Added list to store features
//
//   @override
//   void initState() {
//     _datesellController.text = "";
//     _datebuyController.text = "";
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     // Dispose controllers and scroll controller
//     _brandController.dispose();
//     _modelController.dispose();
//     _priceController.dispose();
//     _quantityController.dispose();
//     _detailController.dispose();
//     _costController.dispose();
//     _datebuyController.dispose();
//     _datesellController.dispose();
//     super.dispose();
//     _scrollController.dispose();
//   }
//   void addFeature() {
//     setState(() {
//       if (_featureController.text.isNotEmpty) {
//         features.add(_featureController.text);
//         _featureController.clear();
//       }
//     });
//   }
//
//
//   void _onScroll() {
//     // Implement onScroll logic if needed
//   }
//
//   Future<void> _refreshData() async {
//     // Implement refresh data logic if needed
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: RefreshIndicator(
//         onRefresh: _refreshData,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             padding: EdgeInsets.all(16),
//             child: Container(
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text(
//                       'Wallet Upload',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     const SizedBox(height: 20),
//                     StreamBuilder<QuerySnapshot>(
//                       stream:
//                       FirebaseFirestore.instance.collection('Wallet_Brand').snapshots(),
//                       builder: (context, snapshot) {
//                         if (!snapshot.hasData) {
//                           return CircularProgressIndicator();
//                         }
//                         final clients = snapshot.data?.docs.reversed.toList();
//                         return DropdownButtonFormField(
//                           items: [
//                             DropdownMenuItem(
//                               value: "0",
//                               child: Text('Select Brand'),
//                             ),
//                             for (var client in clients!)
//                               DropdownMenuItem(
//                                 value: client.id,
//                                 child: Text(client['Wallet Brand']),
//                               ),
//                           ],
//                           decoration: inputDecoration(
//                             labelText: 'Select Brand',
//                           ),
//                           iconEnabledColor: Colors.black,
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 15,
//                           ),
//                           dropdownColor: Colors.white,
//                           onChanged: (clientValue) {
//                             setState(() {
//                               selectedcategory = clientValue!;
//                             });
//                           },
//                           value: selectedcategory,
//                           isExpanded: false,
//                         );
//                       },
//                     ),
//                     SizedBox(height:10),
//                     TextFormField(
//                       controller: _modelController,
//                       keyboardType: TextInputType.text,
//                       decoration: inputDecoration(
//                         hintText: '',
//                         labelText: 'Model',
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please fill this field';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       controller: _priceController,
//                       keyboardType: TextInputType.number,
//                       decoration: inputDecoration(
//                         hintText: '',
//                         labelText: 'Price',
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please fill this field';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       controller: _quantityController,
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                       keyboardType: TextInputType.number,
//                       decoration: inputDecoration(
//                         hintText: '',
//                         labelText: 'Available',
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please fill this field';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       minLines: 1,
//                       maxLines: 10,
//                       controller: _detailController,
//                       keyboardType: TextInputType.text,
//                       decoration: inputDecoration(
//                         hintText: 'Full detail ',
//                         labelText: 'Detail',
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please fill this field';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       controller: _featureController, // Controller for features
//                       keyboardType: TextInputType.text,
//                       decoration: inputDecoration(
//                         hintText: '',
//                         labelText: 'Feature',
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: addFeature,
//                       icon: Icon(Icons.add), // Replace with your desired icon
//                     ),
//                     SizedBox(height: 10),
//                     SizedBox(
//                       height: 130, // Provide a fixed height or adjust as needed
//                       child: ListView.builder(
//                         itemCount: features.length,
//                         itemBuilder: (context, index) {
//                           return ListTile(
//                             title: Text(features[index]),
//                             trailing: IconButton(
//                               icon: Icon(Icons.close), // Add close icon
//                               onPressed: () {
//                                 setState(() {
//                                   // Remove the feature from the list
//                                   features.removeAt(index);
//                                 });
//                               },
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       controller: _costController,
//                       keyboardType: TextInputType.number,
//                       decoration: inputDecoration(
//                         hintText: '',
//                         labelText: 'Cost',
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please fill this field';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       controller: _datebuyController,
//                       decoration: inputDecoration(
//                         labelText: 'Date Buy',
//                       ),
//                       readOnly: true,
//                       onTap: () async {
//                         DateTime? pickedDate = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(2024),
//                           lastDate: DateTime(2200),
//                         );
//                         if (pickedDate != null) {
//                           String formatDate = DateFormat('dd-MM-yyyy').format(pickedDate);
//                           setState(() {
//                             _datebuyController.text = formatDate;
//                           });
//                         } else {
//                           _datebuyController.text = "DD-MM-YYYY";
//                         }
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       controller: _datesellController,
//                       decoration: inputDecoration(
//                         labelText: 'Date Sell',
//                       ),
//                       readOnly: true,
//                       onTap: () async {
//                         DateTime? pickedDate = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(2024),
//                           lastDate: DateTime(2200),
//                         );
//                         if (pickedDate != null) {
//                           String formatDate = DateFormat('dd-MM-yyyy').format(pickedDate);
//                           setState(() {
//                             _datesellController.text = formatDate;
//                           });
//                         } else {
//                           _datesellController.text = "DD-MM-YYYY";
//                         }
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       children: <Widget>[
//                         Checkbox(
//                           value: checkBoxValue,
//                           onChanged: (value) {
//                             setState(() {
//                               checkBoxValue = value!;
//                             });
//                           },
//                         ),
//                         Text("Active"),
//                       ],
//                     ),
//                     SizedBox(height: 16),
//                     ElevatedButton.icon(
//                       onPressed: () async {
//                         if (!isUploading) {
//                           ImagePicker imagePicker = ImagePicker();
//                           List<XFile>? files = await imagePicker.pickMultiImage();
//
//                           if (files == null || files.isEmpty) return;
//
//                           try {
//                             setState(() {
//                               isUploading = true;
//                             });
//
//                             // Upload each selected image to Firebase Storage
//                             for (XFile file in files) {
//                               Reference referenceRoot = FirebaseStorage.instance.ref();
//                               Reference referenceDirImages = referenceRoot.child('images');
//                               Reference referenceImageToUpload =
//                               referenceDirImages.child(DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');
//
//                               await referenceImageToUpload.putFile(
//                                 File(file.path),
//                                 SettableMetadata(contentType: 'image/jpeg'),
//                               );
//
//                               // Get the download URL of the uploaded image
//                               String imageUrl = await referenceImageToUpload.getDownloadURL();
//                               imageUrls.add(imageUrl);
//                             }
//                           } catch (error) {
//                             print('Error uploading image: $error');
//                           } finally {
//                             setState(() {
//                               isUploading = false;
//                             });
//                           }
//                         }
//                       },
//                       icon: Icon(Icons.camera_alt),
//                       label: Text('Upload Images'),
//                       style: ElevatedButton.styleFrom(
//                         primary: Colors.purpleAccent,
//                         onPrimary: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Container(
//                       height: 100,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: imageUrls.length,
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Image.network(
//                               imageUrls[index],
//                               height: 80,
//                               width: 80,
//                               fit: BoxFit.cover,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () async {
//                         if (_formKey.currentState!.validate() && !isUploading) {
//                           String itemModel = _modelController.text;
//                           String itemPrice = _priceController.text;
//                           String itemQuantity = _quantityController.text;
//                           String itemDetail = _detailController.text;
//                           String itemCost = _costController.text;
//                           String itemDatebuy = _datebuyController.text;
//                           String itemDatesell = _datesellController.text;
//
//                           if (imageUrls.isNotEmpty) {
//                             setState(() {
//                               isUploading = true;
//                             });
//
//                             Map<String, dynamic> dataToSend = {
//                               'brand': selectedcategory,
//                               'model': itemModel,
//                               'price': itemPrice,
//                               'quantity': itemQuantity,
//                               'detail': itemDetail,
//                               'cost': itemCost,
//                               'datebuy': itemDatebuy,
//                               'datesell': itemDatesell,
//                               'active': checkBoxValue,
//                               'images': imageUrls, // Use 'images' to store multiple image URLs
//                               'features': features, // Add 'features' array to data
//                             };
//
//                             // Save data to Firestore
//                             await FirebaseFirestore.instance.collection('wallet_list').add(dataToSend);
//
//                             // Clear form fields and imageUrls list
//                             _brandController.clear();
//                             _modelController.clear();
//                             _priceController.clear();
//                             _quantityController.clear();
//                             _detailController.clear();
//                             _costController.clear();
//                             _datebuyController.clear();
//                             _datesellController.clear();
//                             setState(() {
//                               imageUrls.clear();
//                               features.clear(); // Clear features list
//                               isUploading = false;
//                             });
//
//                             // Optionally show a success dialog
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text('Form submitted successfully!'),
//                               ),
//                             );
//                           } else {
//                             // Handle the case where imageUrls list is empty (optional)
//                             print('Please upload images before submitting.');
//                             setState(() {
//                               isUploading = false;
//                             });
//                           }
//                         }
//                       },
//                       child: Text('Submit'),
//                     ),
//                     SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   InputDecoration inputDecoration({
//     String? hintText,
//     String? labelText,
//     IconData? prefixIcon,
//   }) =>
//       InputDecoration(
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(width: 1, color: Colors.deepPurple),
//           borderRadius: BorderRadius.circular(5.5),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.black,
//           ),
//         ),
//         prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.black) : null,
//         filled: true,
//         fillColor: Colors.white,
//         labelText: labelText,
//         labelStyle: TextStyle(color: Colors.black),
//         hintText: hintText,
//       );
// }
