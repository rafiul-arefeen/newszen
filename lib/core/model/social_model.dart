class SocialModel {
  final String id;
  final String title;
  final List<String> imageUrls; // List of image URLs
  final List<String> videoUrls; // List of video URLs
  final String source;
  final DateTime dateTime;
  final String description;
  final String topic;
  final String language;
  final int likeCount;
  final int priority;

  SocialModel({
    required this.id,
    required this.title,
    required this.imageUrls,
    required this.videoUrls,
    required this.source,
    required this.dateTime,
    required this.description,
    required this.topic,
    required this.language,
    required this.likeCount,
    required this.priority,
  });

  factory SocialModel.fromJson(Map<String, dynamic> json) {
    return SocialModel(
      id: json['_id']?.toString() ?? '', // Handle null for id
      title: json['title'] ?? '', // Handle null for title
      imageUrls: (json['image_urls'] as List<dynamic>?)?.cast<String>() ?? [], // Handle null for image_urls
      videoUrls: (json['video_urls'] as List<dynamic>?)?.cast<String>() ?? [], // Handle null for video_urls
      source: json['source'] ?? '', // Handle null for source
      dateTime: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(), // Handle null for timestamp
      description: json['description'] ?? '', // Handle null for content
      topic: json['topic'] ?? '', // Handle null for tag
      language: json['language'] ?? '', // Handle null for language
      likeCount: json['like_count'] ?? 0, // Handle null for like_count
      priority: json['priority'] ?? 0, // Handle null for priority
    );
  }
}