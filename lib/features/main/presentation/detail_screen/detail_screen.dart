import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:intl/intl.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'bloc/detail_cubit.dart';

class NewsDetailPage extends StatefulWidget {
  final NewsModel newsItem;

  const NewsDetailPage({required this.newsItem, super.key});

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  late NewsModel newsItem;
  bool isLiked = false;
  late final DetailCubit _detailCubit;
  late ScrollController _scrollController;
  Color appBarColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    newsItem = widget.newsItem;
    _detailCubit = context.read<DetailCubit>();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset > 150) {
            appBarColor = Colors.white;
          } else {
            appBarColor = Colors.transparent;
          }
        });
      });
  }

  void _onLikeClick(String id,String category, String source) async {
    await _detailCubit.validateLikeIcon(context, id,category,source);
  }
  void _onSaveClick(String id,String category, String source) async {
    await _detailCubit.validateSaveIcon(context, id,category,source);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM dd, yyyy')
        .format(widget.newsItem.dateTime ?? DateTime(2000, 1, 1));
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<DetailCubit, DetailState>(
        builder: (context, state) {
          bool isLiked = state.isLiked; // Access via getter
          bool isSaved = state.isSaved; // Access via getter

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: MediaQuery.of(context).size.height * 0.4,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.newsItem.imageurl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.9),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 36,
                        right: 20,
                        child: SingleChildScrollView(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.newsItem.topic,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${widget.newsItem.source} | ',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat'),
                                ),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                MediaQuery.of(context).size.width * 0.7,
                              ),
                              child: Text(
                                widget.newsItem.title,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Montserrat'),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async =>
                                      _onLikeClick(newsItem.id,newsItem.topic,newsItem.source),
                                  icon: Icon(
                                    state.isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    color: state.isLiked
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: ()  async =>
                                      _onSaveClick(newsItem.id,newsItem.topic,newsItem.source),
                                  icon: Icon(
                                    Icons.save,
                                    color: state.isSaved
                                        ? Colors.red
                                        : Colors.white,),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.share, color: Colors.white),
                                ),
                              ],
                            ),

                            //
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                pinned: true,
              ),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.newsItem.description,
                          style: const TextStyle(
                              fontSize: 16, fontFamily: 'Montserrat'),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            _openNewsUrl(context, widget.newsItem.url);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary_red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Go to Website',
                            style: TextStyle(fontFamily: 'Montserrat'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openNewsUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri,
          mode:
          LaunchMode.externalApplication); // Use external application mode
    } else {
      throw 'Could not launch $url';
    }
  }
}
