import 'package:flutter/material.dart';
import '../widgets/subject_topic_input.dart';
import 'study_plan_screen.dart';
import '../widgets/plan_list_drawer.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _topicsController = TextEditingController();
  final FocusNode _subjectFocusNode = FocusNode();
  final FocusNode _topicsFocusNode = FocusNode();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Widget _buildSubjectTopicInput() {
    return SubjectTopicInput(
      subjectController: _subjectController,
      topicsController: _topicsController,
      subjectFocusNode: _subjectFocusNode,
      topicsFocusNode: _topicsFocusNode,
    );
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  Future<void> _pickDate() async {
    _subjectFocusNode.unfocus();
    _topicsFocusNode.unfocus();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  Future<void> _pickTime(bool isStart) async {
    _subjectFocusNode.unfocus();
    _topicsFocusNode.unfocus();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        isStart ? _startTime = picked : _endTime = picked;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFE0FF), // Light purple
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.deepPurple),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Create Plan',
          style: TextStyle(color: Colors.deepPurple),
        ),
      ),
      drawer: const PlanListDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubjectTopicInput(),

            const SizedBox(height: 32),
            const Text(
              'Scheduling',
              style: TextStyle(color: Colors.deepPurple, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Date Picker
            GestureDetector(
              onTap: _pickDate,
              child: _buildSelectorField(
                text: _selectedDate == null
                    ? 'Select Date/Deadline'
                    : _selectedDate!.toString().split(' ')[0],
                icon: Icons.arrow_drop_down,
              ),
            ),
            const SizedBox(height: 12),

            // Start Time
            GestureDetector(
              onTap: () => _pickTime(true),
              child: _buildSelectorField(
                text: _startTime == null ? 'Starting Time' : _startTime!.format(context),
                icon: Icons.add,
              ),
            ),
            const SizedBox(height: 12),

            // End Time
            GestureDetector(
              onTap: () => _pickTime(false),
              child: _buildSelectorField(
                text: _endTime == null ? 'Ending Time' : _endTime!.format(context),
                icon: Icons.add,
              ),
            ),

            const Spacer(),

            // Create Plan Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final subject = _subjectController.text.trim();
                  final topicList = _topicsController.text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList();

                  if (subject.isEmpty || topicList.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter subject and topics')),
                    );
                    return;
                  }

                  if (_selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a date/deadline')),
                    );
                    return;
                  }

                  if (_startTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a start time')),
                    );
                    return;
                  }

                  if (_endTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select an end time')),
                    );
                    return;
                  }

                  final start = DateTime(
                    _selectedDate!.year,
                    _selectedDate!.month,
                    _selectedDate!.day,
                    _startTime!.hour,
                    _startTime!.minute,
                  );
                  final end = DateTime(
                    _selectedDate!.year,
                    _selectedDate!.month,
                    _selectedDate!.day,
                    _endTime!.hour,
                    _endTime!.minute,
                  );

                  if (end.isBefore(start)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('End time must be after start time')),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudyPlanScreen(
                        subject: subject,
                        topicList: topicList,
                        studyDate: _selectedDate!,
                        startTime: _startTime!,
                        endTime: _endTime!,
                      ),
                    ),
                  );
                }

                ,style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Create Plan",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
              ),
            ),
          ],
        ),
      ),
     );
  }


  Widget _buildSelectorField({required String text, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.grey))),
        ],
      ),
    );
  }
}
