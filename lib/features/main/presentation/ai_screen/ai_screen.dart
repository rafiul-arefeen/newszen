import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // For handling URL clicks

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/custom_appbar.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  // Simulate sending a message
  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.insert(0, ChatMessage(isUserMessage: true, message: text));
    });

    _messageController.clear();

    final response = await _getChatbotResponse(text);
    setState(() {
      _messages.insert(0, response);
    });
  }

  // Fetch chatbot response from the API
  Future<ChatMessage> _getChatbotResponse(String message) async {
    const String apiUrl = "https://chat-zen.vercel.app/predict"; // Replace with your server URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"query": message}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String ragResponse = responseData["rag_response"] ?? "No response from chatbot.";
        final String source = responseData["source"] ?? "Unknown Source";
        final String url = responseData["url"] ?? "#";
        final String dateTime = responseData["dateTime"] ?? DateTime.now().toString();

        return ChatMessage(
          isUserMessage: false,
          message: ragResponse,
          source: source,
          url: url,
          dateTime: dateTime,
        );
      } else {
        return ChatMessage(
          isUserMessage: false,
          message: "Error: ${response.statusCode}, ${response.body}",
        );
      }
    } catch (e) {
      return ChatMessage(
        isUserMessage: false,
        message: "Failed to connect to chatbot: $e",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: main_background_colour,
      appBar: const CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom * 0.0), // Reduces push-up effect
        child: Column(
          children: [
            // Message List
            Expanded(
              child: ListView.builder(
                reverse: true, // Messages appear from bottom
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ChatBubble(
                    isUserMessage: message.isUserMessage,
                    message: message.message,
                    source: message.source,
                    url: message.url,
                    dateTime: message.dateTime,
                  );
                },
              ),
            ),
            // Message Input Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F1F1), // Light grey background for input field
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (text) => _sendMessage(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: primary_red),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // Added space beneath the input field
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final bool isUserMessage;
  final String message;
  final String? source; // Source of the news
  final String? url; // Clickable URL
  final String? dateTime; // Date and time of the news

  ChatMessage({
    required this.isUserMessage,
    required this.message,
    this.source,
    this.url,
    this.dateTime,
  });
}

class ChatBubble extends StatelessWidget {
  final bool isUserMessage;
  final String message;
  final String? source;
  final String? url;
  final String? dateTime;

  const ChatBubble({
    super.key,
    required this.isUserMessage,
    required this.message,
    this.source,
    this.url,
    this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isUserMessage ? primary_red : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the message
            Text(
              message,
              style: TextStyle(
                color: isUserMessage ? Colors.white : Colors.black,
                fontSize: 14,
              ),
            ),
            // Display source, URL, and dateTime if available
            if (source != null || url != null || dateTime != null)
              const SizedBox(height: 8),
            if (source != null)
              Text(
                "Source: $source",
                style: TextStyle(
                  color: isUserMessage ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            if (dateTime != null)
              Text(
                "Date: $dateTime",
                style: TextStyle(
                  color: isUserMessage ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            if (url != null)
              InkWell(
                onTap: () async {
                  if (await canLaunch(url!)) {
                    await launch(url!);
                  } else {
                    print("Could not launch $url");
                  }
                },
                child: Text(
                  "URL: $url",
                  style: TextStyle(
                    color: isUserMessage ? Colors.white.withOpacity(0.8) : Colors.blue,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }
}