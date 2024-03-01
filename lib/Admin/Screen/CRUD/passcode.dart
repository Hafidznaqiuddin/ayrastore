import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CodeRepository {
  final CollectionReference codesCollection = FirebaseFirestore.instance.collection('codes');

  Future<void> insertCode(String code) async {
    try {
      await codesCollection.add({'code': code});
    } catch (e) {
      print('Error inserting code: $e');
      throw e; // Rethrow the error to handle it elsewhere if needed
    }
  }

  Future<String?> getCurrentCode() async {
    try {
      final querySnapshot = await codesCollection.get();
      if (querySnapshot.docs.isNotEmpty) {
        final currentCode = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return currentCode['code'] as String?;
      }
    } catch (e) {
      print('Error fetching current code: $e');
    }
    return null;
  }

  Future<void> updateCode(String newCode) async {
    try {
      final querySnapshot = await codesCollection.get();
      if (querySnapshot.docs.isNotEmpty) {
        final codeId = querySnapshot.docs.first.id;
        await codesCollection.doc(codeId).update({'code': newCode});
      }
    } catch (e) {
      print('Error updating code: $e');
    }
  }
}

class CodeUpdateScreen extends StatefulWidget {
  @override
  _CodeUpdateScreenState createState() => _CodeUpdateScreenState();
}

class _CodeUpdateScreenState extends State<CodeUpdateScreen> {
  final TextEditingController _newCodeController = TextEditingController();
  final CodeRepository _codeRepository = CodeRepository();
  String? _currentCode;

  @override
  void initState() {
    super.initState();
    _fetchCurrentCode();
  }

  Future<void> _fetchCurrentCode() async {
    final currentCode = await _codeRepository.getCurrentCode();
    setState(() {
      _currentCode = currentCode;
      _newCodeController.text = _currentCode ?? ''; // Set the text field value
    });
  }

  @override
  void dispose() {
    _newCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _newCodeController,
              decoration: InputDecoration(
                labelText: 'Enter New Code',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final newCode = _newCodeController.text.trim();
                if (newCode.isNotEmpty && newCode.length == 4) {
                  await _codeRepository.updateCode(newCode);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Code updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _newCodeController.clear();
                  _fetchCurrentCode(); // Refresh current code after update
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid code.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
