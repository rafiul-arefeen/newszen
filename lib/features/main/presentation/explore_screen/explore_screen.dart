import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/data/remote/mock_data.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';
import 'package:news_zen/core/widgets/horizontal_news_card.dart';
import 'package:news_zen/core/widgets/news_card.dart';
import 'package:news_zen/features/main/presentation/search_screen/search_screen.dart';
import 'package:news_zen/features/main/presentation/search_screen/bloc/search_bloc.dart';
import 'package:news_zen/features/main/presentation/notifications_screen/notifications_screen.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../explore_popular_screen/bloc/explore_popular_bloc.dart';
import '../explore_popular_screen/explore_popular_screen.dart';
import 'bloc/explore_bloc.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExploreBloc()..add(LoadExploreDataEvent()),
      child: Scaffold(
        appBar: const CustomAppBar(),
        backgroundColor: main_background_colour,
        body: BlocBuilder<ExploreBloc, ExploreState>(
          builder: (context, state) {
            if (state is ExploreLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExploreLoadedState) {
              return _buildExploreScreen(context, state);
            } else if (state is ExploreErrorState) {
              return Center(child: Text(state.error));
            }
            return const Center(child: Text('Something went wrong!'));
          },
        ),
      ),
    );
  }

  Widget _buildExploreScreen(BuildContext context, ExploreLoadedState state) {
    final TextEditingController _searchController = TextEditingController();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE3E3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      onSubmitted: (query) {
                        if (query.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => SearchBloc()
                                  ..add(SearchQueryChanged(query)),
                                child: const SearchScreen(),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton(
                      icon: const Icon(Icons.search, color: Colors.grey),
                      onPressed: () {
                        final query = _searchController.text;
                        if (query.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => SearchBloc()
                                  ..add(SearchQueryChanged(query)),
                                child: const SearchScreen(),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Popular Tags Section
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Popular Tags',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                'National', 'World', 'Politics', 'Sports', 'Technology', 'Entertainment'
              ].map((text) {
                return GestureDetector(
                  onTap: () {
                    // Fetch popular news for the selected tag
                    //context.read<ExploreBloc>().add(FetchPopularNewsEvent(text));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => ExplorePopularBloc()
                            ..add(exploreQueryChanged(text.toLowerCase())),
                          child: const ExplorePopularScreen(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Recommended Section
          Padding(
            padding: const EdgeInsets.only(top: 22.0, left: 22.0, right: 22.0, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Recommended',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 8, top: 8, right: 8.0),
            child: ListView.builder(
              itemCount: context.read<ExploreBloc>().loadRecomendedData().length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final newsItem = context.read<ExploreBloc>().loadRecomendedData()[index];
                return NewsCard(newsItem: newsItem);
              },
            ),
          ),
        ],
      ),
    );
  }
}