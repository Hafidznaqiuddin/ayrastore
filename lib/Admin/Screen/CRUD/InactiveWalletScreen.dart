// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
//
// class InactiveWalletsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           '',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('wallet_list').where('active', isEqualTo: false).snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No inactive items found.'));
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           var items = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: items.length,
//             itemBuilder: (context, index) {
//               var item = items[index];
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Card(
//                   elevation: 2,
//                   child: ListTile(
//                     title: Text(item['brand'] ?? ''),
//                     subtitle: Text(item['model'] ?? ''),
//                     leading: _buildLeadingImage(item),
//                     onTap: () async {
//                       await FirebaseFirestore.instance.collection('wallet_list').doc(item.id).update({'active': true});
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildLeadingImage(DocumentSnapshot item) {
//     final List<dynamic>? images = item['images'];
//     if (images != null && images.isNotEmpty && images[0] != null) {
//       return Image.network(
//         images[0],
//         width: 50,
//         height: 50,
//         fit: BoxFit.cover,
//       );
//     } else {
//       return Container(
//         width: 50,
//         height: 50,
//         color: Colors.grey.withOpacity(0.5),
//         child: Icon(Icons.image),
//       );
//     }
//   }
// }
