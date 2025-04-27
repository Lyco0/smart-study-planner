import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import 'package:flutter_markdown/flutter_markdown.dart';


class StudyChatPage extends StatefulWidget {
  const StudyChatPage({super.key});

  @override
  StudyChatPageState createState() => StudyChatPageState();
}

class StudyChatPageState extends State<StudyChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  bool _isLoading = false;

  void _sendMessage() async {
    final userInput = _controller.text.trim();
    if (userInput.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': userInput});
      _isLoading = true;
      _controller.clear();
    });

    final aiReply = await GeminiService.chatWithAI(userInput);

    // Clean up bullet points
    final cleanedReply = aiReply.replaceAll(RegExp(r'^\s*[-*+]\s+', multiLine: true), '');

    setState(() {
      _messages.add({'sender': 'ai', 'text': cleanedReply});
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Ask AI'),backgroundColor: Color(0xFFE0D6FE)),
        backgroundColor: Color(0xFFE0D6FE),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isUser = message['sender'] == 'user';

                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.deepPurple[300] : Colors.deepPurple[50],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: message['text'] != null
                              ? MarkdownBody(
                            data: message['text']!,
                            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                          )
                              : Text(''),
                        ),
                      );
                    },
                  ),
                ),
                if (_isLoading)
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Text('AI is thinking...', style: TextStyle(color: Color(0xff000000))),
                  ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Ask your study assistant...',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(35)),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _sendMessage,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}
