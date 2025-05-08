import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'study_chat_page.dart';
import '../widgets/study_plan_popup_menu.dart';


class StudyPlanScreen extends StatefulWidget {
  final String subject;
  final List<String> topicList;
  final DateTime studyDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const StudyPlanScreen({
    super.key,
    required this.subject,
    required this.topicList,
    required this.studyDate,
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

  String planName = 'My Study Plan';
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
    final today = DateTime.now();
    final formattedToday = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    final formattedDeadline = "${widget.studyDate.year}-${widget.studyDate.month.toString().padLeft(2, '0')}-${widget.studyDate.day.toString().padLeft(2, '0')}";
    final formattedStartTime = widget.startTime.format(context);
    final formattedEndTime = widget.endTime.format(context);

    final prompt = '''
Create a detailed study plan for the subject "${widget.subject}" covering the following topics: ${widget.topicList.join(', ')}.
The study plan should be within the date and time range of $formattedStartTime, $formattedEndTime, $formattedToday and $formattedDeadline
Make sure the plan is student-friendly, realistic, and clear. 

Details:
- 📚 Subject: "${widget.subject}"
- 📝 Topics: ${widget.topicList.join(', ')}
- 📅 Study Start Date: $formattedToday
- 📅 Deadline Date: $formattedDeadline
- ⏰ Daily Study Time: $formattedStartTime to $formattedEndTime

Instructions:
- The plan must start from $formattedToday and end on $formattedDeadline.
- Spread out the topics intelligently over the available days.
- Ensure the time spent per day does not exceed the provided range.
- Validate the subject and topics. If they are invalid or unrelated, do not generate a plan and return a polite message.
- Don't use columns and rows to display the plan.
''';


    try {
      final response = await GeminiService.generatePlan(prompt);
      if (_isDisposed) return;

      setState(() {
        aiPlan = response;
        isLoading = false;
      });
    } catch (e) {
      if (_isDisposed) return;
      setState(() {
        aiPlan = '❌ Failed to generate plan. Please try again.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(planName), backgroundColor: const Color(0xFFE0D6FE),
        actions: [
        StudyPlanPopupMenu(
        currentPlanName: planName,
        subject: widget.subject,
        topics: widget.topicList,
        planMarkdown: aiPlan,
        startTime: widget.startTime,
        endTime: widget.endTime,
        onRename: (newName) {
          setState(() {
            planName = newName;
          });
        },
      ),
      ],
      ),
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
