import 'package:flutter/material.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:intl/intl.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/features/main/presentation/detail_screen/detail_screen.dart';


class NewsCard extends StatelessWidget {
  final NewsModel newsItem;

  const NewsCard({required this.newsItem, super.key});

  String formatDate(DateTime? date) {
    if (date == null) return "Unknown date";
    return DateFormat("MMM dd, yyyy").format(date);
  }

  @override
  Widget build(BuildContext context) {
    // Format the date with a fallback if newsItem.dateTime is null
    //String formattedDate = DateFormat('MMM dd, yyyy').format(newsItem.dateTime ?? DateTime(2000, 1, 1));

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailPage(newsItem: newsItem),
            ),
          );
        },
        child: Container(
          color: main_background_colour,
          height: 100,
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newsItem.title,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: "montserrat"
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          newsItem.source,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(width: 4.0),
                        const Text('|'),
                        const SizedBox(width: 4.0),
                        Text(
                          formatDate(newsItem.dateTime), // Use the formatted date here
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(32.0),
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      newsItem.imageurl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}