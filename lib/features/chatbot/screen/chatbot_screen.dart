import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import '../services/gemini_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final GeminiService _geminiService = GeminiService();
  final ChatUser _currentUser = ChatUser(
    id: '1',
    firstName: 'User',
    lastName: '',
  );
  final ChatUser _bot = ChatUser(
    id: '2',
    firstName: 'Assistant',
    lastName: '',
  );

  List<ChatMessage> messages = [];
  bool _isLoading = false;

  void _handleSendPressed(ChatMessage message) async {
    setState(() {
      messages.insert(0, message);
      _isLoading = true;
    });

    try {
      final response = await _geminiService.getCodingResponse(message.text);

      final botMessage = ChatMessage(
        user: _bot,
        createdAt: DateTime.now(),
        text: response,
      );

      setState(() {
        messages.insert(0, botMessage);
        _isLoading = false;
      });
    } catch (e) {
      final errorMessage = ChatMessage(
        user: _bot,
        createdAt: DateTime.now(),
        text: "Sorry, I encountered an error: ${e.toString()}",
      );

      setState(() {
        messages.insert(0, errorMessage);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Coding Assistant',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: DashChat(
        currentUser: _currentUser,
        onSend: _handleSendPressed,
        messages: messages,
        inputOptions: InputOptions(
          sendButtonBuilder: (onSend) => IconButton(
            icon: const Icon(Icons.send),
            onPressed: onSend,
          ),
        ),
        messageOptions: MessageOptions(
          showTime: true,
          containerColor: Theme.of(context).primaryColor,
          textColor: Colors.white,
          messagePadding: const EdgeInsets.all(10),
        ),
        typingUsers: _isLoading ? [_bot] : [],
      ),
    );
  }
}
