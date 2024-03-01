import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationForm extends StatefulWidget {
  @override
  _NotificationFormState createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _submitNotification() {
    // Submit admin notification
    FirebaseFirestore.instance.collection('admin').get().then((querySnapshot) {
      querySnapshot.docs.forEach((userDoc) {
        userDoc.reference.collection('notification').add({
          'title': _titleController.text,
          'message': _messageController.text,
          'timestamp': DateTime.now(),
        }).then((_) {
          _titleController.clear();
          _messageController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Admin notification submitted successfully',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green, // Success color
            ),
          );
        }).catchError((error) {
          // Handle errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to submit admin notification: $error',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red, // Error color
            ),
          );
        });
      });
    });

    // Submit user notification
    FirebaseFirestore.instance.collection('user').get().then((querySnapshot) {
      querySnapshot.docs.forEach((userDoc) {
        userDoc.reference.collection('notification').add({
          'title': _titleController.text,
          'message': _messageController.text,
          'timestamp': DateTime.now(),
        }).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'User notification submitted successfully',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green, // Success color
            ),
          );
        }).catchError((error) {
          // Handle errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to submit user notification: $error',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red, // Error color
            ),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Notification',
          style: TextStyle(color: Colors.white),
        ), // App bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _submitNotification,
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple, // Button color
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Button padding
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
