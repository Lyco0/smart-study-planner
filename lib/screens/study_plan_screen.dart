import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'study_chat_page.dart';
import 'package:flutter/services.dart';

class StudyPlanScreen extends StatefulWidget {
  final String subject;
  final List<String> topicList;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const StudyPlanScreen({
    super.key,
    required this.subject,
    required this.topicList,
    required this.startTime,
    required this.endTime,
  });

  @override
  StudyPlanScreenState createState() => StudyPlanScreenState();
}

class StudyPlanScreenState extends State<StudyPlanScreen> {
  String aiPlan = '';
  bool isLoading = true;
  bool _isDisposed = false; // Add this

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) { // Use this
      if (!_isDisposed) { // Check if the widget is disposed
        generateStudyPlan();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true; // And this
    super.dispose();
  }

  Future<void> generateStudyPlan() async {
    final formattedStartTime = widget.startTime.format(context);
    final formattedEndTime = widget.endTime.format(context);

    final prompt = '''
Create a detailed study plan for the subject "${widget.subject}" covering the following topics: ${widget.topicList.join(', ')}.
The study plan should be within the time range of $formattedStartTime and $formattedEndTime.
Make sure the plan is student-friendly, realistic, and clear. Also check for the topics and Subject if it's real or not. If the subject and topics do not correspond to any known subject or topic, then don't create any plan.
''';

    try {
      final response = await GeminiService.generatePlan(prompt);
      if (_isDisposed) return; // Don't update state if disposed

      setState(() {
        aiPlan = response;
        isLoading = false;
      });
    } catch (e) {
      if (_isDisposed) return; // Don't update state if disposed
      setState(() {
        aiPlan = '❌ Failed to generate plan. Please try again.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Study Plan'), backgroundColor: const Color(0xFFE0D6FE)),
      backgroundColor: const Color(0xFFE0D6FE),
      body: Stack(
        children: [
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
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                        speed: const Duration(milliseconds: 50),
                      ),
                      TypewriterAnimatedText(
                        'Just a moment...',
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                        speed: const Duration(milliseconds: 50),
                      ),
                      TypewriterAnimatedText(
                        'Almost ready...',
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                        speed: const Duration(milliseconds: 50),
                      ),
                      TypewriterAnimatedText(
                        'Final touches...',
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                        speed: const Duration(milliseconds: 50),
                      ),
                      TypewriterAnimatedText(
                        'Your plan is almost ready!',
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                        speed: const Duration(milliseconds: 50),
                      ),
                    ],
                    totalRepeatCount: 999,
                    pause: const Duration(milliseconds: 1000),
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
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Markdown(
                      data: aiPlan,
                      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 🔹 Floating action buttons
          Positioned(
            bottom: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: aiPlan));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Study plan copied to clipboard!')),
                    );
                  },
                  backgroundColor: Colors.deepPurple[200],
                  tooltip: 'Copy Plan',
                  child: const Icon(Icons.copy),
                ),
                const SizedBox(width: 16), // Add some spacing between the buttons
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StudyChatPage()),
                    );
                  },
                  backgroundColor: Colors.deepPurple[200],
                  tooltip: 'Ask Study Assistant',
                  child: const Icon(Icons.chat),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

