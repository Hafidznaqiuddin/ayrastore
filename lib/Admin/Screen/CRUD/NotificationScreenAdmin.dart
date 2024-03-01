import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../User/ScreenUser/DisplayInfomation.dart';

class NotificationScreenAdmin extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreenAdmin> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _notificationStream;

  @override
  void initState() {
    super.initState();
    _getNotificationsForCurrentAdmin();
  }

  void _getNotificationsForCurrentAdmin() {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _notificationStream = FirebaseFirestore.instance
        .collection('admin')
        .doc(currentUserId)
        .collection('notification')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _notificationStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final documents = snapshot.data!.docs;

          if (documents.isEmpty) {
            return Center(child: Text('No new notifications'));
          }

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final notification = documents[index].data();
              if (notification.containsKey('message')) {
                return _buildMessageCard(notification, documents[index].id);
              } else {
                return _buildNotificationCard(notification, documents[index].id);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildMessageCard(Map<String, dynamic> notification, String documentId) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      child: Dismissible(
        key: Key(documentId),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Icon(Icons.delete, color: Colors.white),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          // Remove the notification from Firestore
          FirebaseFirestore.instance
              .collection('admin')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('notification')
              .doc(documentId)
              .delete();
        },
        child: ListTile(
          title: Text(
            notification['title'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(notification['message']),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, String documentId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayInfomation(
              images: notification['images'] ?? [], // Use empty list if images is null
              brand: notification['brand'] ?? '', // Use empty string if brand is null
              model: notification['model'] ?? '', // Use empty string if model is null
              price: notification['price'] ?? '', // Use empty string if price is null
              detail: notification['detail'] ?? '', // Use empty string if detail is null
              quantity: notification['quantity'] ?? '', // Use empty string if quantity is null
              features: notification['features'] ?? [], // Use empty list if features is null
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.all(8),
        child: Dismissible(
          key: Key(documentId),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            // Remove the notification from Firestore
            FirebaseFirestore.instance
                .collection('admin')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('notification')
                .doc(documentId)
                .delete();
          },
          child: ListTile(
            leading: Image.network(
              notification['images'][0], // Assuming the first image is displayed as a thumbnail
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(
              notification['brand'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${notification['category']} - ${notification['price']}'),
          ),
        ),
      ),
    );
  }
}
