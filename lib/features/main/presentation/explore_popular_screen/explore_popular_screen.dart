import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:news_zen/core/widgets/news_card.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'bloc/explore_popular_bloc.dart';

class ExplorePopularScreen extends StatelessWidget {
  const ExplorePopularScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: main_background_colour,
        title: const Text(
          'Explore by Tag',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: BlocBuilder<ExplorePopularBloc, exploreState>(
          builder: (context, state) {
            if (state is exploreLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is exploreLoaded) {
              if (state.results.isEmpty) {
                return const Center(
                  child: Text(
                    'No results found. Try another explore!',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.results.length,
                itemBuilder: (context, index) {
                  final newsItem = state.results[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NewsCard(newsItem: newsItem),
                  );
                },
              );
            } else if (state is exploreError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return const Center(
              child: Text(
                'Enter a explore query to see results.',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
