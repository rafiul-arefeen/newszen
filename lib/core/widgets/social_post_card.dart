import 'package:flutter/material.dart';
import 'package:news_zen/core/model/social_model.dart';
import 'package:news_zen/core/theme/colors.dart';

class SocialPostCard extends StatelessWidget {
  final SocialModel post;

  const SocialPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    // Split the source field into account name and username
    final List<String> sourceParts = post.source.split(',');
    final String accountName = sourceParts[0].trim();
    final String username = sourceParts.length > 1 ? sourceParts[1].trim() : '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      color: Colors.white, // Set the background color to white
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with platform logo, account name, and username
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Platform logo (always Twitter)
                Image.asset(
                  'assets/social_icons/twitter.png', // Replace with your Twitter logo path
                  width: 32,
                  height: 32,
                ),
                const SizedBox(width: 12),
                // Account name and username
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      accountName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    if (username.isNotEmpty)
                      Text(
                        '@$username',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'Montserrat',
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Date and time of the post
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Posted on: ${_formatDateTime(post.dateTime)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Post content (description)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              post.description,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'Montserrat',
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Helper function to format the date and time
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}