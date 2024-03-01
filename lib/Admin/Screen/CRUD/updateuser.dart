import 'package:ayrastore/Admin/Screen/CRUD/viewadmin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateUserPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const UpdateUserPage({Key? key, required this.data}) : super(key: key);

  @override
  _UpdateUserPageState createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.data['Full Name']);
    _emailController = TextEditingController(text: widget.data['email']);
    _phoneController = TextEditingController(text: widget.data['Number phone']);
    _passController = TextEditingController(text: widget.data['password']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _deleteUser() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure?"),
          content: Text("This action will permanently delete the user."),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await FirebaseFirestore.instance.collection('admin').doc(widget.data['uid']).delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User deleted successfully'),
                  ),
                );
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => ItemListManager()));// Navigate back to the previous screen after deletion
              },
              child: Text("Delete"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User'),
        actions: <Widget>[
          IconButton(
            onPressed: _deleteUser,
            icon: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passController,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance.collection('admin').doc(widget.data['uid']).update({
                        'Full Name': _nameController.text,
                        'email': _emailController.text,
                        'Number phone': _phoneController.text,
                        'password': _passController.text,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('User data updated successfully'),
                        ),
                      );
                      print('Document updated successfully');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update user data: ${e.toString()}'),
                        ),
                      );
                      print('Error updating document: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurpleAccent,
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
}
