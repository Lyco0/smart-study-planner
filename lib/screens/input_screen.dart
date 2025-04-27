import 'package:flutter/material.dart';
import 'study_plan_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});
  @override
  InputScreenState createState() => InputScreenState();
}

class InputScreenState extends State<InputScreen> {
  String? selectedSubject;
  TextEditingController topicController = TextEditingController();
  final subjectController = TextEditingController();
  final topicsController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Study Setup'),backgroundColor: Color(0xFFE0D6FE)),
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFE0D6FE),
      body: Stack(
        children: [
          // 🔹 Main UI layer
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(labelText: 'Subject'),
                ),
                TextField(
                  controller: topicsController,
                  decoration: InputDecoration(labelText: 'Topics'),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      selectedDate == null
                          ? 'Select Deadline'
                          : 'Deadline: ${selectedDate?.toLocal().toString().split(' ')[0] ?? 'Not selected'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(Duration(days: 1)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Text('Pick Date'),
                    ),
                  ],
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    final subject = subjectController.text.trim();
                    final topicList = topicsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList();

                    if (selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a deadline date')),
                      );
                      return;
                    }
                    if (subject.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a subject')),
                      );
                      return;
                    }
                    if (topicList.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter at least one topic')),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudyPlanScreen(
                          subject: subjectController.text,
                          topicList: topicList,
                          deadline: selectedDate!,
                        ),
                      ),
                    );
                  },
                  child: Text('Create Plan'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
