import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FAQUpdateScreen extends StatefulWidget {
  final String documentId;

  const FAQUpdateScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  _FAQUpdateScreenState createState() => _FAQUpdateScreenState();
}

class _FAQUpdateScreenState extends State<FAQUpdateScreen> {
  List<List<TextEditingController>> _controllersLists = [];
  List<Widget> _forms = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('faq').doc(widget.documentId).get();
      Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('faq_data')) {
        List<dynamic> faqData = data['faq_data'];

        List<List<TextEditingController>> controllersLists = [];
        List<Widget> forms = [];

        for (int i = 0; i < faqData.length; i++) {
          String number = faqData[i]['number'] ?? '';
          String question = faqData[i]['question'] ?? '';
          String answer = faqData[i]['answer'] ?? '';
          TextEditingController numberController = TextEditingController(text: number);
          TextEditingController questionController = TextEditingController(text: question);
          TextEditingController answerController = TextEditingController(text: answer);
          controllersLists.add([numberController, questionController, answerController]);
          forms.add(_buildFAQFields(i, numberController, questionController, answerController));
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

  Widget _buildFAQFields(int index, TextEditingController numberController, TextEditingController questionController, TextEditingController answerController) {
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
                  'FAQ ${index + 1}',
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
              decoration: InputDecoration(
                labelText: 'Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: questionController,
              decoration: InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: answerController,
              decoration: InputDecoration(
                labelText: 'Answer',
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
      List<Map<String, String>> updatedFaqData = [];
      for (int i = 0; i < _controllersLists.length; i++) {
        String number = _controllersLists[i][0].text;
        String question = _controllersLists[i][1].text;
        String answer = _controllersLists[i][2].text;
        if (question.isNotEmpty && answer.isNotEmpty) {
          updatedFaqData.add({
            'number': number,
            'question': question,
            'answer': answer,
          });
        }
      }
      await FirebaseFirestore.instance.collection('faq').doc(widget.documentId).update({
        'faq_data': updatedFaqData,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('FAQ data updated successfully'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update FAQ data: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update FAQ Data'),
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
            TextEditingController numberController = TextEditingController();
            TextEditingController questionController = TextEditingController();
            TextEditingController answerController = TextEditingController();
            _controllersLists.add([numberController, questionController, answerController]);
            _forms.add(_buildFAQFields(_controllersLists.length - 1, numberController, questionController, answerController));
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
