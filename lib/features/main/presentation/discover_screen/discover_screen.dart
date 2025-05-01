import 'package:flutter/material.dart';
import 'package:news_zen/core/data/remote/mock_data.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:news_zen/core/widgets/news_card.dart';
import 'package:news_zen/core/widgets/news_search_delegate.dart';


class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final List<String> _newsSources = ['CNN', 'BBC', 'Al Jazeera', 'The Daily Star', 'The Guardian', 'Prothom Alo'];
  final List<String> _sourceLogos = [
    'assets/logos/cnn.png',
    'assets/logos/bbc.jpg',
    'assets/logos/aljazeera.png',
    'assets/logos/thedailystar.png',
    'assets/logos/theguardian.jpg',
    'assets/logos/prothomalo.jpeg',
  ];


  final List<String> topics = ['All', 'World', 'Sports', 'Technology', 'Health', 'Space', 'Food', 'Politics', 'Automotive'];


  String? _selectedSource;
  String selectedTopic = 'All';


  void _toggleSource(String source) {
    setState(() {
      _selectedSource = (_selectedSource == source) ? null : source;
    });
  }


  List<NewsModel> getFilteredNews() {
    List<NewsModel> filteredNews = mockNewsData;


    if (_selectedSource != null) {
      filteredNews = filteredNews.where((news) => news.source == _selectedSource).toList();
    }


    if (selectedTopic != 'All') {
      filteredNews = filteredNews.where((news) => news.topic == selectedTopic).toList();
    }

    return filteredNews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0, top: 20.0),
          child: Text(
            'Discover',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 0.0, right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.red),
              iconSize: 36,
              padding: const EdgeInsets.only(right: 00.0, top: 00.0),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: NewsSearchDelegate(mockNewsData),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),

            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _newsSources.length,
                itemBuilder: (context, index) {
                  final source = _newsSources[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () => _toggleSource(source),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage(_sourceLogos[index]),
                            child: (_selectedSource == source)
                                ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black, width: 4),
                              ),
                            )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 0),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: topics.map((topic) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedTopic = topic;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedTopic == topic ? Colors.red : Colors.white,
                          foregroundColor: selectedTopic == topic ? Colors.white : Colors.black,
                        ),
                        child: Text(topic),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'All News',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: getFilteredNews().length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final newsItem = getFilteredNews()[index];
                  return NewsCard(newsItem: newsItem);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}