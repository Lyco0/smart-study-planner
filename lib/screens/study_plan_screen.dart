import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/gemini_service.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'study_chat_page.dart';

class StudyPlanScreen extends StatefulWidget {

  final String subject;
  final List<String> topicList;
  final DateTime deadline;

  const StudyPlanScreen({
    super.key,
    required this.subject,
    required this.topicList,
    required this.deadline,
  });

  @override
  StudyPlanScreenState createState() => StudyPlanScreenState();
}

class StudyPlanScreenState extends State<StudyPlanScreen> {
  String aiPlan = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    generateStudyPlan();
  }

  Future<void> generateStudyPlan() async {

    final today = DateTime.now();
    final formattedToday = DateFormat('yyyy-MM-dd').format(today);
    final formattedDeadline = DateFormat('yyyy-MM-dd').format(widget.deadline);

    // Calculate duration
    final totalDays = widget.deadline.difference(today).inDays + 1;
    final totalWeeks = (totalDays / 7).ceil();

    final prompt = '''
Create a detailed study plan for the subject "${widget.subject}" covering the following topics: ${widget.topicList.join(', ')}.
Distribute the topics evenly over the $totalDays days (approximately $totalWeeks weeks) between today ($formattedToday) and the deadline ($formattedDeadline).
Make sure the plan is student-friendly, realistic, and clear. Also check for the topics and Subject if it's real or not. If the subject and topics do not correspond to any known subject or topic, then don't create any plan.
''';

    try {
      final response = await GeminiService.generatePlan(prompt);
      final cleanedResponse = response.replaceAll(RegExp(r'^\s*\*\s+', multiLine: true), '');

      setState(() {
        aiPlan = cleanedResponse;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        aiPlan = '❌ Failed to generate plan. Please try again.';
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Study Plan'),backgroundColor: Color(0xFFE0D6FE)),
      backgroundColor: Color(0xFFE0D6FE),
      body: Stack(
        children: [
          // 🔹 Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitFadingCube(
                    color: Theme.of(context).primaryColor,
                    size: 50.0,
                  ),
                  const SizedBox(height: 24),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Generating study plan...',
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                        speed: const Duration(milliseconds: 50),
                      ),
                      TypewriterAnimatedText(
                        'Just a moment...',
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                        speed: const Duration(milliseconds: 50),
                      ),
                      TypewriterAnimatedText(
                        'Almost ready...',
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                        speed: const Duration(milliseconds: 50),
                      ),
                      TypewriterAnimatedText(
                        'Final touches...',
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                        speed: const Duration(milliseconds: 50),
                      ),
                      TypewriterAnimatedText(
                        'Your plan is almost ready!',
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                        speed: const Duration(milliseconds: 50),
                      ),
                    ],
                    totalRepeatCount: 999,
                    pause: Duration(milliseconds: 1000),
                    displayFullTextOnTap: false,
                    stopPauseOnTap: false,
                  ),
                ],
              ),
            )
                : Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[50],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade600,
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Markdown(
                      data: aiPlan,
                      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudyChatPage()),
          );
        },
        backgroundColor: Colors.deepPurple[200],
        tooltip: 'Ask Study Assistant',
        child: Icon(Icons.chat),
      ),
    );
  }
}
