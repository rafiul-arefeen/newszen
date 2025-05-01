// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:news_zen/core/data/remote/mock_data.dart';
// import 'package:news_zen/core/model/news_model.dart';
// import 'package:news_zen/core/theme/colors.dart';
// import 'package:news_zen/core/utils/app_assets.dart';
// import 'package:news_zen/core/widgets/horizontal_news_card.dart';
// import 'package:news_zen/core/widgets/news_card.dart';
// import 'package:news_zen/features/main/presentation/home_screen/bloc/news_cubit.dart';
// import 'package:news_zen/features/main/presentation/home_screen/bloc/news_state.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//
// import '../notifications_screen/notifications_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen>  {
//
//   late ScrollController _scrollController;
//   late final NewsCubit _newsCubit;
//   String selectedTopic = 'All';
//   final List<String> topics = ['All', 'World', 'Sports', 'Technology', 'Health', 'Space', 'Food', 'Politics', 'Automotive'];
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _scrollController.addListener(_scrollListener);
//     _newsCubit = context.read<NewsCubit>();
//   }
//   void _scrollListener() {
//     if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
//       // Load more data when the user scrolls to the bottom
//       print("Reached Bottom! Fetching more data...");
//       context.read<NewsCubit>().loadNews(currentPage: context.read<NewsCubit>().currentPage );
//     }
//   }
//   List<NewsModel> getFilteredNews() {
//     if (selectedTopic == 'All') {
//       return _newsCubit.pageViewNews;
//     }
//     return _newsCubit.pageViewNews.where((news) => news.topic == selectedTopic).toList();
//
//   }
//
//
//   final PageController _pageController = PageController();
//   int currentPage = 0;
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(100),
//         child: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: main_background_colour,
//           title: Column(
//             children: [
//               SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left:8.0),
//                     child: Image.asset(
//                       AppAssets.image.img_med_logo,
//                       width: 140,
//                     ),
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     onPressed: () {
//                       showNotificationScreen(context);
//                     },
//                     icon: Icon(
//                         Icons.notifications, color: primary_red
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       backgroundColor: main_background_colour,
//       body:
//       BlocBuilder<NewsCubit, NewsState>(
//         builder: (context, state) {
//           if (state is NewsLoading) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state is NewsError) {
//             return Center(child: Text("Failed to  news"));
//           }
//           return Column(
//             children: [
//               SingleChildScrollView(
//
//                 scrollDirection: Axis.horizontal,
//
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: topics.map((topic) {
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 8.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           TextButton(
//                             onPressed: () {
//                               setState(() {
//                                 selectedTopic = topic;
//                               });
//                             },
//                             style: TextButton.styleFrom(
//                               foregroundColor: selectedTopic == topic ? Colors.red : Colors.black,
//                               padding: EdgeInsets.zero, // Removes padding for minimal look
//                             ),
//                             child: Text(
//                               topic,
//                               style: TextStyle(
//                                 fontSize: 12, // Set font size
//                                 fontWeight: FontWeight.bold, // Adjust font weight if needed
//                                 fontFamily: 'Montserrat', // Replace with desired font family
//                               ),
//                             ),
//                           ),
//                           if (selectedTopic == topic)
//                             Container(
//                               margin: const EdgeInsets.only(top: 4.0),
//                               height: 2,
//                               width: 20,
//                               color: Colors.red, // Color of the underline
//                             ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   controller: _scrollController,
//                   child:  Column(
//                     children: [
//                       SizedBox(
//                         height: 20,),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                         child: SizedBox(
//                           height: 200,
//                           child: PageView.builder(
//                             controller: _pageController,
//                             scrollDirection: Axis.horizontal,
//                             itemCount: _newsCubit.pageViewNews.length /*+ (context.read<NewsCubit>().hasMoreData ? 1 : 0)*/,
//                             onPageChanged: (int index) {
//                               setState(() {
//                                 currentPage = index;
//                               });
//                             },
//                             itemBuilder: (context, index) {
//                               /* if(index==_newsCubit.horizontalNews.length)
//                                 {
//                                   return Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Center(child: CircularProgressIndicator()),
//                                   );
//                                 }*/
//                               final newsItem = _newsCubit.pageViewNews[index];
//                               return HorizontalNewsCard(newsItem: newsItem);
//                             },
//                             pageSnapping: true,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16.0),
//                       Center(
//                         child: SmoothPageIndicator(
//                           controller: _pageController,
//                           count: _newsCubit.pageViewNews.length,
//                           effect: ExpandingDotsEffect(
//                             dotHeight: 8.0,
//                             dotWidth: 8.0,
//                             activeDotColor: Colors.red,
//                             dotColor: Colors.grey.shade400,
//                           ),
//                         ),
//                       ),
//                       //suggestions
//                       const SizedBox(height: 30.0),
//                       const Padding(
//                         padding: EdgeInsets.only(left: 25.0, right: 8.0, bottom: 8.0),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Browse By',
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black,
//                                 fontFamily: "montserrat"
//                             ),
//                           ),
//                         ),
//                       ),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: topics.map((topic) {
//                             return Padding(
//                               padding: const EdgeInsets.only(right: 8.0),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   TextButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         selectedTopic = topic;
//                                       });
//                                     },
//                                     style: TextButton.styleFrom(
//                                       foregroundColor: selectedTopic == topic ? Colors.red : Colors.black,
//                                       padding: EdgeInsets.zero, // Removes padding for minimal look
//                                     ),
//                                     child: Text(
//                                       topic,
//                                       style: TextStyle(
//                                         fontSize: 12, // Set font size
//                                         fontWeight: FontWeight.bold, // Adjust font weight if needed
//                                         fontFamily: 'Montserrat', // Replace with desired font family
//                                       ),
//                                     ),
//                                   ),
//                                   if (selectedTopic == topic)
//                                     Container(
//                                       margin: const EdgeInsets.only(top: 4.0),
//                                       height: 2,
//                                       width: 20,
//                                       color: Colors.red, // Color of the underline
//                                     ),
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                       NotificationListener<ScrollNotification>(
//                         onNotification: (scrollNotification) {
//                           if (scrollNotification.metrics.pixels >= scrollNotification.metrics.maxScrollExtent - 100) {
//                             context.read<NewsCubit>().loadNews(currentPage: context.read<NewsCubit>().currentPage);
//                           }
//                           return false;
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(left:20,bottom:8,top:8,right:8.0),
//                           child: ListView.builder(
//                             controller: _scrollController,
//                             itemCount: _newsCubit.filterHorizontalNews(selectedTopic).length + (context.read<NewsCubit>().hasMoreData ? 1 : 0),
//                             shrinkWrap: true,
//                             physics: const BouncingScrollPhysics(),
//                             itemBuilder: (context, index) {
//                               if(index==_newsCubit.horizontalNews.length)
//                               {
//                                 return Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: CircularProgressIndicator(),
//                                 );
//                               }
//                               final newsItem = _newsCubit.filterHorizontalNews(selectedTopic)[index];
//                               return NewsCard(newsItem: newsItem);
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
// class NewsSourceCircle extends StatelessWidget{
//   final String imagePath;
//
//   NewsSourceCircle({required this.imagePath});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//
//         decoration: BoxDecoration(
//           color: Colors.grey[200], // Set the fill color for the CircleAvatar
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2), // Shadow color
//               spreadRadius: 1,
//               blurRadius: 5, // Controls the softness of the shadow
//               offset: Offset(0, 3), // Controls the position of the shadow
//             ),
//           ],
//         ),
//         child: CircleAvatar(
//           radius: 25,
//           foregroundImage: AssetImage(imagePath),
//           backgroundColor: Colors.transparent, // Keeps the CircleAvatar background transparent
//         ),
//       ),
//     );
//
//
//   }
//
//
// }
//
// class CategoryTab extends StatelessWidget {
//
//   final String title;
//   final bool isSelected;
//
//   CategoryTab({required this.title, this.isSelected = false});
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//         fontFamily: 'Montserrat',
//       ),
//     );
//   }
//
// }