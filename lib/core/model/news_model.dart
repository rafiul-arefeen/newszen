import 'package:intl/intl.dart';

class NewsModel {
  final String id;
  final String title;
  final String imageurl;
  final String source;
  final String description;
  final String url;
  final String topic;
  final DateTime? dateTime;
  final String language;
  final int likecount;
  final int priority;

  NewsModel({
    required this.id,
    required this.title,
    required this.imageurl,
    required this.source,
    required this.description,
    required this.url,
    required this.topic,
    this.dateTime,
    required this.language,
    required this.likecount,
    required this.priority,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      imageurl: json['imageurl'],
      source: json['source'],
      description: json['description'],
      url: json['url'],
      topic: json['topic'],
      language: json['language'],
      likecount: json['likecount'] ?? 0, // Defaulting to 0 if null
      priority: json['priority'] ?? 0,
      dateTime: _parseDateTime(json['dateTime']),
    );
  }

  /// Function to parse dateTime in multiple formats
  static DateTime _parseDateTime(dynamic dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.toString().isEmpty) {
      return DateTime.now();
    }

    try {
      // Try parsing as ISO 8601 (e.g., "2025-10-02T18:00:00.000Z")
      return DateTime.parse(dateTimeStr);
    } catch (_) {
      try {
        // If ISO parsing fails, try "dd-MM-yy" format
        return DateFormat("dd-MM-yy").parse(dateTimeStr);
      } catch (_) {
        // If both fail, return today's date
        return DateTime.now();
      }
    }
  }
}
