import 'package:flutter/material.dart';
import '../models/saved_plan_model.dart';
import '../services/saved_plan_repository.dart';

class StudyPlanPopupMenu extends StatelessWidget {
  final String currentPlanName;
  final String subject;
  final List<String> topics;
  final String planMarkdown;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Function(String newName) onRename;

  const StudyPlanPopupMenu({
    super.key,
    required this.currentPlanName,
    required this.subject,
    required this.topics,
    required this.planMarkdown,
    required this.startTime,
    required this.endTime,
    required this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'rename':
            _showRenameDialog(context);
            break;
          case 'save':
            _savePlan(context);
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'rename', child: Text('Rename Plan')),
        PopupMenuItem(value: 'save', child: Text('Save Plan')),
      ],
    );
  }

  void _showRenameDialog(BuildContext context) async {
    String tempName = currentPlanName;
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Plan'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Enter plan name'),
          onChanged: (value) => tempName = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, tempName.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            child: const Text('Rename', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty) {
      onRename(newName);
    }
  }

  void _savePlan(BuildContext context) async {
    final timeRange = '${startTime.format(context)} - ${endTime.format(context)}';
    final plan = SavedPlan(
      name: currentPlanName,
      subject: subject,
      topics: topics,
      planMarkdown: planMarkdown,
      timeRange: timeRange,
    );

    await SavedPlanRepository.savePlan(plan);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Study Plan saved.')),
    );
  }
}
