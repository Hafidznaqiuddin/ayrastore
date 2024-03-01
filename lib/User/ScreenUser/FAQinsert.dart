import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'FAQupdate.dart';

class FAQInsertScreen extends StatefulWidget {
  const FAQInsertScreen({Key? key}) : super(key: key);

  @override
  _FAQInsertScreenState createState() => _FAQInsertScreenState();
}

class _FAQInsertScreenState extends State<FAQInsertScreen> {
  late List<TextEditingController> _questionControllers = List.generate(
    10,
        (index) => TextEditingController(),
  );
  late List<TextEditingController> _answerControllers = List.generate(
    10,
        (index) => TextEditingController(),
  );

  void _submitFAQ(List<Map<String, String>> faqData) async {
    try {
      // Combine questions and answers into a single list
      List<Map<String, String>> faqList = [];
      for (int i = 0; i < 10; i++) {
        String question = _questionControllers[i].text;
        String answer = _answerControllers[i].text;
        if (question.isNotEmpty && answer.isNotEmpty) {
          faqList.add({
            'question': question,
            'answer': answer,
          });
        }
      }

      // Add the faqList to Firestore as an array
      await FirebaseFirestore.instance.collection('faq').doc('faq_data').set({
        'faq_data': faqList,
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('FAQ data added successfully'),
        ),
      );

      // Clear all the form fields
      for (var controller in _questionControllers) {
        controller.clear();
      }
      for (var controller in _answerControllers) {
        controller.clear();
      }
    } catch (error) {
      // Show an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add FAQ data: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter FAQ Data:',
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
                          controller: _questionControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Question ${index + 1}',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _answerControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Answer ${index + 1}',
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
                  // Combine questions and answers into a list of FAQ data
                  List<Map<String, String>> faqData = [];
                  for (int i = 0; i < 10; i++) {
                    String question = _questionControllers[i].text;
                    String answer = _answerControllers[i].text;
                    if (question.isNotEmpty && answer.isNotEmpty) {
                      faqData.add({
                        'question': question,
                        'answer': answer,
                      });
                    }
                  }
                  if (faqData.isNotEmpty) {
                    _submitFAQ(faqData);
                  }
                },
                child: Text('Submit'),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FAQUpdateScreen(documentId: 'faq_data')),
                  );
                },
                icon: Icon(Icons.update),
                label: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
