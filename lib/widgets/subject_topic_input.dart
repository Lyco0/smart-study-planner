import 'package:flutter/material.dart';

class SubjectTopicInput extends StatelessWidget {
  final TextEditingController subjectController;
  final TextEditingController topicsController;
  final FocusNode subjectFocusNode;
  final FocusNode topicsFocusNode;

  const SubjectTopicInput({
    super.key,
    required this.subjectController,
    required this.topicsController,
    required this.subjectFocusNode,
    required this.topicsFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: subjectController,
          focusNode: subjectFocusNode,
          decoration: InputDecoration(
            hintText: 'SUBJECT',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: topicsController,
          focusNode: topicsFocusNode,
          decoration: InputDecoration(
            hintText: 'TOPICS',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}