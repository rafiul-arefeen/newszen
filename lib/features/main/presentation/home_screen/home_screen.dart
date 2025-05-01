
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/widgets/custom_appbar.dart';
import 'package:news_zen/core/data/remote/mock_data.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';
import 'package:news_zen/core/widgets/horizontal_news_card.dart';
import 'package:news_zen/core/widgets/news_card.dart';
import 'package:news_zen/features/main/presentation/home_screen/bloc/news_cubit.dart';
import 'package:news_zen/features/main/presentation/home_screen/bloc/news_state.dart';
import 'package:news_zen/features/main/presentation/news_sites_screen/news_sites_screen.dart';
import 'package:news_zen/features/main/presentation/notifications_screen/notifications_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  {


  late final NewsCubit _newsCubit;
  String selectedTopicPageview = 'all';
  final List<String> topicsPageview = ['all', 'national', 'world', 'politics', 'sports', 'business', 'finance', 'technology', 'entertainment'];
  String selectedTopicListView = 'all';
  final List<String> topicsListview = ['all', 'Trending', 'Popular', 'Latest', 'MostViewed'];
  final List<Map<String, String>> newsSources = [
    //{'name': 'BBC', 'imagePath': AppAssets.image.img_bbc_logo},
    {'name': 'CNN', 'imagePath': AppAssets.image.img_cnn_logo},
    {'name': 'Al Zazeera', 'imagePath': AppAssets.image.img_aljazeera_logo},
    //{'name': 'Prothom Alo', 'imagePath': AppAssets.image.img_prothom_alo_logo},
    {'name': 'The Daily Star', 'imagePath': AppAssets.image.img_daily_star_logo},
    {'name': 'bdnews24', 'imagePath': AppAssets.image.img_bdnews24_logo},
    {'name': 'The Daily Ittefaq', 'imagePath': AppAssets.image.img_ittefaq_logo},
    //{'name': 'mzamin', 'imagePath': AppAssets.image.img_mzamin_logo},
  ];
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _newsCubit = context.read<NewsCubit>();
    _scrollController.addListener((){
      if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
        print('lazy loading working');
        /*_newsCubit.currentPage++;
        _newsCubit.loadData(currentDataPage: _newsCubit.currentPage);*/
        _loadMoreNews(selectedTopicPageview);
      }
    });
  }
  void _loadMoreNews(String topic) {
    if (_newsCubit.hasMoreData) {
      _newsCubit.fetchMoreNews(topic); // Pass topic parameter to fetch function
    }
  }

  List<NewsModel> getFilteredNews() {
    if (selectedTopicPageview == 'All') {
      return _newsCubit.pageViewNews;
    }
    return _newsCubit.pageViewNews.where((news) => news.topic == selectedTopicPageview).toList();

  }


  final PageController _pageController = PageController();
  int currentPage = 0;
  bool initialnewsload = false;
  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }
  Widget? previousWidget;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body:
      BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          if (state is NewsError) {
            return Center(child: Text("Failed to  news"));
          }
          if(state is NewsLoading)
          {
            initialnewsload = true;
            return previousWidget ?? Center(child: CircularProgressIndicator());
          }
          else if(state is NewsLoaded || state is TrendingNewsLoading || state is TrendingNewsLoaded)
          {
            previousWidget =Column(
              children: [
                SingleChildScrollView(
                  //first filter design
                  scrollDirection: Axis.horizontal,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: topicsPageview.map((topic) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedTopicPageview = topic;
                                });
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: selectedTopicPageview == topic ? Colors.red : Colors.black,
                                padding: EdgeInsets.zero, // Removes padding for minimal look
                              ),
                              child: Text(
                                topic,
                                style: TextStyle(
                                  fontSize: 12, // Set font size
                                  fontWeight: FontWeight.bold, // Adjust font weight if needed
                                  fontFamily: 'Montserrat', // Replace with desired font family
                                ),
                              ),
                            ),
                            if (selectedTopicPageview == topic)
                              Container(
                                margin: const EdgeInsets.only(top: 4.0),
                                height: 2,
                                width: 20,
                                color: Colors.red, // Color of the underline
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child:  Column(
                      children: [
                        SizedBox(
                          height: 20,),

                        Padding(
                          //first news card
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox(
                            height: 200,
                            child: PageView.builder(
                              controller: _pageController,
                              scrollDirection: Axis.horizontal,
                              itemCount: _newsCubit.filterPageViewNews(selectedTopicPageview).length/* + (context.read<NewsCubit>().hasMoreData ? 1 : 0)*/, /*+ (context.read<NewsCubit>().hasMoreData ? 1 : 0)*/
                              onPageChanged: (int index) {
                                setState(() {
                                  currentPage = index;
                                });
                              },
                              itemBuilder: (context, index) {

                                final newsItem =_newsCubit.filterPageViewNews(selectedTopicPageview)[index];
                                return HorizontalNewsCard(newsItem: newsItem);
                              },
                              pageSnapping: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Center(
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: /*_newsCubit.pageViewNews.length*/_newsCubit.filterPageViewNews(selectedTopicPageview).length,
                            effect: ExpandingDotsEffect(
                              dotHeight: 8.0,
                              dotWidth: 8.0,
                              activeDotColor: Colors.red,
                              dotColor: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        //suggestions
                        const SizedBox(height: 30.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children to the edges
                            children: [
                              // "Popular Redactions" text aligned to the left
                              const Text(
                                'Popular Redactions',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontFamily: "montserrat",
                                ),
                              ),
                              // "See All" text aligned to the right and clickable
                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => const NewsSitesScreen(selectedSource: '',),
                              //       ),
                              //     );
                              //     print('See All clicked');
                              //   },
                              //   child: Text(
                              //     'See All',
                              //     style: TextStyle(
                              //       fontSize: 16,
                              //       fontWeight: FontWeight.w600,
                              //       color: Colors.grey,
                              //       decoration: TextDecoration.underline,
                              //       fontFamily: "montserrat",
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          // child: SingleChildScrollView(
                          //   scrollDirection: Axis.horizontal,
                          //   child: Row(
                          //     children: newsSources.map((source) {
                          //       return NewsSourceCircle(
                          //         name: source['name']!,
                          //         imagePath: source['imagePath']!,
                          //         onTap: () => Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (context) => NewsSitesScreen(selectedSource: source['name']!,),
                          //           ),
                          //         )
                          //       );
                          //     }).toList(),
                          //   ),
                          // ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center, // Center the items horizontally
                              children: newsSources.map((source) {
                                return NewsSourceCircle(
                                  name: source['name']!,
                                  imagePath: source['imagePath']!,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsSitesScreen(selectedSource: source['name']!),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        const Padding(
                          padding: EdgeInsets.only(left: 25.0, right: 8.0, bottom: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Browse By',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontFamily: "montserrat"
                              ),
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          //list news filter
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: topicsListview.map((topic) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedTopicListView = topic;
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: selectedTopicListView == topic ? Colors.red : Colors.black,
                                        padding: EdgeInsets.zero, // Removes padding for minimal look
                                      ),
                                      child: Text(
                                        topic,
                                        style: TextStyle(
                                          fontSize: 12, // Set font size
                                          fontWeight: FontWeight.bold, // Adjust font weight if needed
                                          fontFamily: 'Montserrat', // Replace with desired font family
                                        ),
                                      ),
                                    ),
                                    if (selectedTopicListView == topic)
                                      Container(
                                        margin: const EdgeInsets.only(top: 4.0),
                                        height: 2,
                                        width: 20,
                                        color: Colors.red, // Color of the underline
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 500,

                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Padding(
                              padding: const EdgeInsets.only(left:20,bottom:8,top:8,right:8.0),
                              child: ListView.builder(

                                itemCount: _newsCubit.filterHorizontalNews(selectedTopicListView).length /*+ (context.read<NewsCubit>().hasMoreData ? 1 : 0)*/,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final newsItem = _newsCubit.filterHorizontalNews(selectedTopicListView)[index];
                                  return NewsCard(newsItem: newsItem);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
            return previousWidget!;
          };

          //hopefully lagbe na eita
          return Column(
            children: [
              SingleChildScrollView(
                //horizontal news filter
                scrollDirection: Axis.horizontal,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: topicsListview.map((topic) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedTopicListView = topic;
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: selectedTopicListView == topic ? Colors.red : Colors.black,
                              padding: EdgeInsets.zero, // Removes padding for minimal look
                            ),
                            child: Text(
                              topic,
                              style: TextStyle(
                                fontSize: 12, // Set font size
                                fontWeight: FontWeight.bold, // Adjust font weight if needed
                                fontFamily: 'Montserrat', // Replace with desired font family
                              ),
                            ),
                          ),
                          if (selectedTopicListView == topic)
                            Container(
                              margin: const EdgeInsets.only(top: 4.0),
                              height: 2,
                              width: 20,
                              color: Colors.red, // Color of the underline
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child:  Column(
                    children: [
                      SizedBox(
                        height: 20,),
                      Padding(
                        //horizontal news card
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          height: 200,
                          child: PageView.builder(
                            controller: _pageController,
                            scrollDirection: Axis.horizontal,
                            itemCount: _newsCubit.pageViewNews.length /*+ (context.read<NewsCubit>().hasMoreData ? 1 : 0)*/,
                            onPageChanged: (int index) {
                              setState(() {
                                currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {

                              final newsItem = _newsCubit.pageViewNews[index];
                              return HorizontalNewsCard(newsItem: newsItem);
                            },
                            pageSnapping: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: _newsCubit.pageViewNews.length,
                          effect: ExpandingDotsEffect(
                            dotHeight: 8.0,
                            dotWidth: 8.0,
                            activeDotColor: Colors.red,
                            dotColor: Colors.grey.shade400,
                          ),
                        ),
                      ),
                      //suggestions
                      const SizedBox(height: 30.0),
                      const Padding(
                        padding: EdgeInsets.only(left: 25.0, right: 8.0, bottom: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Browse By',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontFamily: "montserrat"
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        //list news filter
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: topicsPageview.map((topic) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedTopicPageview = topic;
                                        _loadMoreNews(selectedTopicPageview);
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: selectedTopicPageview == topic ? Colors.red : Colors.black,
                                      padding: EdgeInsets.zero, // Removes padding for minimal look
                                    ),
                                    child: Text(
                                      topic,
                                      style: TextStyle(
                                        fontSize: 12, // Set font size
                                        fontWeight: FontWeight.bold, // Adjust font weight if needed
                                        fontFamily: 'Montserrat', // Replace with desired font family
                                      ),
                                    ),
                                  ),
                                  if (selectedTopicPageview == topic)
                                    Container(
                                      margin: const EdgeInsets.only(top: 4.0),
                                      height: 2,
                                      width: 20,
                                      color: Colors.red, // Color of the underline
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:20,bottom:8,top:8,right:8.0),
                        child: ListView.builder(

                          itemCount: _newsCubit.filterHorizontalNews(selectedTopicPageview).length + (context.read<NewsCubit>().hasMoreData ? 1 : 0),
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            /*if(index==_newsCubit.horizontalNews.length)
                            {
                              print('rih');
                              return Center(
                                child: CircularProgressIndicator(

                                ),
                              );
                            }*/
                            final newsItem = _newsCubit.fetchMoreNews(selectedTopicPageview)[index];
                            return NewsCard(newsItem: newsItem );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );

        },
      ),
    );
  }
}

class NewsSourceCircle extends StatelessWidget {
  final String imagePath;
  final String name;
  final VoidCallback onTap;

  const NewsSourceCircle({
    required this.name,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: 60,
              height: 60,
            ),
          ),
        ),
      ),
    );
  }
}
