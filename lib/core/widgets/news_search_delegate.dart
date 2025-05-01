import 'package:flutter/material.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:news_zen/features/main/presentation/detail_screen/detail_screen.dart';


class NewsSearchDelegate extends SearchDelegate {
  final List<NewsModel> allNews;
  final double padding;
  final EdgeInsetsGeometry iconPadding;
  final double iconTouchSize;

  NewsSearchDelegate(
      this.allNews, {
        this.padding = 0.0,
        this.iconPadding = const EdgeInsets.all(0.0),
        this.iconTouchSize = 80.0,
      });

  @override
  TextStyle? get searchFieldStyle => const TextStyle(
    fontSize: 18,
    color: Colors.black,
  );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 0),
        child: GestureDetector(
          onTap: () {
            query = '';
          },
          child: Container(
            width: iconTouchSize,
            height: iconTouchSize,
            alignment: Alignment.center,
            child: const Icon(Icons.clear, color: Colors.red),
          ),
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: GestureDetector(
        onTap: () {
          close(context, null);
        },
        child: Container(
          width: iconTouchSize,
          height: iconTouchSize,
          alignment: Alignment.center,
          child: const Icon(Icons.arrow_back, color: Colors.red),
        ),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    List<NewsModel> filteredNews = allNews.where((news) {
      return news.title.toLowerCase().contains(query.toLowerCase()) ||
          news.description.toLowerCase().contains(query.toLowerCase());
    }).toList();


    if (filteredNews.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            "No results found",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
      );
    }


    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: filteredNews.length,
          itemBuilder: (context, index) {
            final newsItem = filteredNews[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: padding),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    title: Text(
                      newsItem.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        newsItem.description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailPage(newsItem: newsItem),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    List<NewsModel> suggestions = allNews.where((news) {
      return news.title.toLowerCase().contains(query.toLowerCase()) ||
          news.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final newsItem = suggestions[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: padding),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(
                      newsItem.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      query = newsItem.title;
                      showResults(context);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}