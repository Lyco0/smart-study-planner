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
  TimeOfDay? selectedStartTime; // Changed to TimeOfDay
  TimeOfDay? selectedEndTime;   // Changed to TimeOfDay

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Study Setup'), backgroundColor: const Color(0xFFE0D6FE)),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFE0D6FE),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
            TextField(
              controller: topicsController,
              decoration: const InputDecoration(labelText: 'Topics'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  selectedStartTime == null
                      ? 'Start Time'
                      : 'Start: ${selectedStartTime?.format(context) ?? 'Not selected'}', //show formatted time
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker( // Use showTimePicker
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedStartTime = pickedTime;
                      });
                    }
                  },
                  child: const Text('Pick Start Time'),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  selectedEndTime == null
                      ? 'End Time'
                      : 'End: ${selectedEndTime?.format(context) ?? 'Not selected'}',  //show formatted time
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker( // Use showTimePicker
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedEndTime = pickedTime;
                      });
                    }
                  },
                  child: const Text('Pick End Time'),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final subject = subjectController.text.trim();
                final topicList = topicsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();

                if (selectedStartTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a start time')),
                  );
                  return;
                }
                if (selectedEndTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select an end time')),
                  );
                  return;
                }
                if (subject.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a subject')),
                  );
                  return;
                }
                if (topicList.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter at least one topic')),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudyPlanScreen(
                      subject: subject,
                      topicList: topicList,
                      startTime: selectedStartTime!, // Pass the times
                      endTime: selectedEndTime!,
                    ),
                  ),
                );
              },
              child: const Text('Create Plan'),
            ),
          ],
        ),
      ),
    );
  }
}