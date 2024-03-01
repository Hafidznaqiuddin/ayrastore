import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class MoneyUpdateScreen extends StatefulWidget {
  final String documentId;

  const MoneyUpdateScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  _MoneyUpdateScreenState createState() => _MoneyUpdateScreenState();
}

class _MoneyUpdateScreenState extends State<MoneyUpdateScreen> {
  List<List<TextEditingController>> _controllersLists = [];
  List<Widget> _forms = [];
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(symbol: '');

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('money_info').doc(widget.documentId).get();
      Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('ranges')) {
        List<dynamic> ranges = data['ranges'];

        List<List<TextEditingController>> controllersLists = [];
        List<Widget> forms = [];

        for (int i = 0; i < ranges.length; i++) {
          String range = ranges[i] as String;
          List<String> rangeParts = range.split(' - ');
          TextEditingController numberController = TextEditingController(text: (i + 1).toString());
          TextEditingController lowerController = TextEditingController(text: rangeParts[0]);
          TextEditingController upperController = TextEditingController(text: rangeParts[1]);
          controllersLists.add([numberController, lowerController, upperController]);
          forms.add(_buildRangeFields(i, numberController, lowerController, upperController));
        }

        setState(() {
          _controllersLists = controllersLists;
          _forms = forms;
        });
      }
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  Widget _buildRangeFields(int index, TextEditingController numberController, TextEditingController lowerController, TextEditingController upperController) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Range ${index + 1}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => _deleteFormField(index),
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                ),
              ],
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: numberController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Form Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: lowerController,
              keyboardType: TextInputType.number,
              inputFormatters: [_formatter],
              decoration: InputDecoration(
                labelText: 'Lower Bound',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: upperController,
              keyboardType: TextInputType.number,
              inputFormatters: [_formatter],
              decoration: InputDecoration(
                labelText: 'Upper Bound',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _deleteFormField(int index) {
    setState(() {
      _controllersLists.removeAt(index);
      _forms.removeAt(index);
    });
  }

  Future<void> _updateData() async {
    try {
      // Sort the form data based on the form number
      _controllersLists.sort((a, b) => int.parse(a[0].text).compareTo(int.parse(b[0].text)));

      List<String> moneyRanges = [];
      for (int i = 0; i < _controllersLists.length; i++) {
        String? lowerBound = _controllersLists[i][1].text; // Nullable string
        String? upperBound = _controllersLists[i][2].text; // Nullable string
        if (lowerBound != null && upperBound != null) {
          String range = '$lowerBound - $upperBound';
          moneyRanges.add(range);
        }
      }

      // Update the sorted ranges in the database
      await FirebaseFirestore.instance.collection('money_info').doc(widget.documentId).update({
        'ranges': moneyRanges,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Money ranges updated successfully'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update money ranges: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Money Ranges'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _forms.length,
                itemBuilder: (context, index) {
                  return _forms[index];
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateData,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Adjust the value as needed
                ),
                padding: EdgeInsets.symmetric(vertical: 10), // Adjust the padding as needed
                backgroundColor: Colors.deepPurple, // Adjust the background color as needed
              ),
              child: Text(
                'Update',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            TextEditingController numberController = TextEditingController(text: (_controllersLists.length + 1).toString());
            TextEditingController lowerController = TextEditingController();
            TextEditingController upperController = TextEditingController();
            _controllersLists.add([numberController, lowerController, upperController]);
            _forms.add(_buildRangeFields(_controllersLists.length - 1, numberController, lowerController, upperController));
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
