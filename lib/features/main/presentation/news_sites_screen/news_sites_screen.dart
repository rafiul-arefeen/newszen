import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';
import 'package:news_zen/core/widgets/news_card.dart';

import 'bloc/news_by_source_bloc.dart';

class NewsSitesScreen extends StatefulWidget {
  final String selectedSource; // Add this parameter

  const NewsSitesScreen({super.key, required this.selectedSource}); // Update constructor

  @override
  State<NewsSitesScreen> createState() => _NewsSitesScreenState();
}

class _NewsSitesScreenState extends State<NewsSitesScreen> {
  late String selectedSource; // Use widget.selectedSource to initialize

  @override
  void initState() {
    super.initState();
    selectedSource = widget.selectedSource; // Initialize with the passed source
    // Fetch news for the selected source when the screen loads
    context.read<NewsBySourceBloc>().add(FetchNewsBySource(source: selectedSource));
  }

  Widget _buildSourceInfo() {
    // Replace this with your logic to fetch the source image and name
    // For example, you might have a map or a function that returns the details based on the source ID
    String sourceImage = AppAssets.image.img_daily_star_logo; // Default image
    String sourceName = selectedSource; // Default name

    // Example logic (replace with your actual implementation)
    if (selectedSource == "cnn") {
      sourceImage = AppAssets.image.img_cnn_logo;
      sourceName = "CNN";
    } else if (selectedSource == "The Daily Star") {
      sourceImage = AppAssets.image.img_daily_star_logo;
      sourceName = "The Daily Star";
    }

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              sourceImage,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          sourceName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Image.asset(
                      AppAssets.image.img_med_logo, // Your logo asset
                      width: 140,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                    icon: Icon(Icons.close, color: primary_red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<NewsBySourceBloc, NewsBySourceState>(
        builder: (context, state) {
          print('BlocBuilder Rebuilt with State: $state'); // Debug print
          if (state is NewsBySourceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsBySourceError) {
            return Center(child: Text(state.message));
          } else if (state is NewsBySourceLoaded) {
            if (state.news.isEmpty) {
              return const Center(
                child: Text(
                  'No news found for this source.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: false,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.news.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Add padding
                  child: NewsCard(newsItem: state.news[index]),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}