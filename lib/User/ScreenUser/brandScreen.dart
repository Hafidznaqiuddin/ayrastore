import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class BrandScreen extends StatefulWidget {
  @override
  _BrandScreenState createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  final TextEditingController _brandController = TextEditingController();
  String _selectedCategory = '';

  Future<void> _addBrand() async {
    String brand = _brandController.text.trim();
    if (brand.isNotEmpty && _selectedCategory.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('brands').add({
          'name': brand,
          'category': _selectedCategory,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Brand added successfully')),
        );
        _brandController.clear();
      } catch (error) {
        print('Error adding brand: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add brand')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Brands'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField(
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value as String;
                });
              },
              items: [], // Populate with categories from Firestore
              decoration: InputDecoration(labelText: 'Select Category'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _brandController,
              decoration: InputDecoration(labelText: 'Brand Name'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addBrand,
              child: Text('Add Brand'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('brands').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final brands = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: brands.length,
                    itemBuilder: (context, index) {
                      final brand = brands[index];
                      return ListTile(
                        title: Text(brand['name']),
                        subtitle: Text('Category: ${brand['category']}'),
                        // Implement delete functionality if needed
                      );
                    },
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