import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/saved_plan_model.dart';

class SavedPlanScreen extends StatelessWidget {
  final SavedPlan plan;

  const SavedPlanScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(plan.name),backgroundColor: const Color(0xFFE0D6FE)),
      backgroundColor: const Color(0xFFE0D6FE),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Markdown(data: plan.planMarkdown),
      ),
    );
  }
}
