import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:news_zen/features/main/presentation/detail_screen/detail_screen.dart';
class LatestNewsCard extends StatelessWidget {
  final NewsModel newsItem;

  const LatestNewsCard({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM dd, yyyy').format(newsItem.dateTime ?? DateTime(2000, 1, 1));

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(newsItem: newsItem),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container with adjusted height and width
            Container(
              height: 150, // Adjusted height for the image
              width: 500, // Ensures the image takes up the full width
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(newsItem.imageurl),
                  fit: BoxFit.cover, // Adjust the image to cover the container
                ),
              ),
            ),
            // Text container (below the image)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black87,
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source and date text
                  Text(
                    '${newsItem.source} | $formattedDate',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      fontFamily: "montserrat",
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Title text
                  Text(
                    newsItem.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: "montserrat",
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

