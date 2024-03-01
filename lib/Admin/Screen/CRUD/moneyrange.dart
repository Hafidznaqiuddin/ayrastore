import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'moneyUpdateScreen.dart';

class MoneyInfoScreen extends StatefulWidget {
  const MoneyInfoScreen({Key? key}) : super(key: key);

  @override
  _MoneyInfoScreenState createState() => _MoneyInfoScreenState();
}

class _MoneyInfoScreenState extends State<MoneyInfoScreen> {
  late List<TextEditingController> _lowerBoundControllers = List.generate(
    10,
        (index) => TextEditingController(),
  );
  late List<TextEditingController> _upperBoundControllers = List.generate(
    10,
        (index) => TextEditingController(),
  );

  void _submitMoneyInfo(List<String> moneyRanges) async {
    try {
      // Add the money ranges to Firestore as an array
      await FirebaseFirestore.instance.collection('money_info').add({
        'ranges': moneyRanges,
      });
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Add data successful'),
        ),
      );
      // Clear all the form fields
      for (var controller in _lowerBoundControllers) {
        controller.clear();
      }
      for (var controller in _upperBoundControllers) {
        controller.clear();
      }
    } catch (error) {
      // Show an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add money ranges: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter Money Ranges:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: _lowerBoundControllers[index],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Lower Bound ${index + 1}',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _upperBoundControllers[index],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Upper Bound ${index + 1}',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Combine lower and upper bounds into an array
                List<String> moneyRanges = [];
                for (int i = 0; i < 10; i++) {
                  String lowerBound = _lowerBoundControllers[i].text;
                  String upperBound = _upperBoundControllers[i].text;
                  if (lowerBound.isNotEmpty && upperBound.isNotEmpty) {
                    moneyRanges.add(' $lowerBound - $upperBound');
                  }
                }
                if (moneyRanges.isNotEmpty) {
                  _submitMoneyInfo(moneyRanges);
                }
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MoneyUpdateScreen(documentId: 'srYXfswsVAnTH9IusTr8')),
                );
              },
              icon: Icon(Icons.update),
              label: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
