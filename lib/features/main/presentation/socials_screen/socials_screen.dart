import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/model/social_model.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/widgets/social_post_card.dart';
import 'package:news_zen/features/main/presentation/socials_screen/bloc/social_news_cubit.dart';
import 'package:news_zen/features/main/presentation/socials_screen/bloc/social_news_state.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/widgets/custom_appbar.dart';

class SocialsPage extends StatefulWidget {
  const SocialsPage({super.key});

  @override
  State<SocialsPage> createState() => _SocialsPageState();
}

class _SocialsPageState extends State<SocialsPage> {
  late final SocialNewsCubit _newsCubit;
  String selectedPlatform = 'All'; // Default to "All"
  String searchQuery = '';
  String selectedTag = 'All';

  final List<String> tags = [
    'All', // Add "All" as the first option
    'Cricket', 'Islam', 'Bangladesh', 'Palestine', 'Football', 'Technology', 'World'
  ];

  @override
  void initState() {
    super.initState();
    _newsCubit = SocialNewsCubit();
    _newsCubit.loadData(currentDataPage: 1); // Fetch initial data
  }

  List<SocialModel> getFilteredPosts(List<SocialModel> posts) {
    return posts.where((post) {
      bool matchesPlatform = selectedPlatform == 'All' || post.source.contains(selectedPlatform);
      bool matchesSearch = searchQuery.isEmpty || post.description.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesTag = selectedTag == 'All' || post.topic.contains(selectedTag);
      return matchesPlatform && matchesSearch && matchesTag;
    }).toList();
  }

  bool isNewPost(DateTime postTime) {
    return DateTime.now().difference(postTime).inHours <= 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8), // Add padding around the body
        child: BlocBuilder<SocialNewsCubit, SocialNewsState>(
          bloc: _newsCubit,
          builder: (context, state) {
            if (state is SocialNewsError) {
              return Center(child: Text("Failed to fetch news: ${state.error}"));
            }
            if (state is SocialNewsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SocialNewsLoaded) {
              final filteredPosts = getFilteredPosts(state.pageViewNews);

              return Column(
                children: [
                  // Platform Toggle with Icons
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     _buildPlatformIcon('All', 'assets/social_icons/globe.png'), // Replace with your icon path
                  //     const SizedBox(width: 10),
                  //     _buildPlatformIcon('Twitter', 'assets/social_icons/twitter.png'), // Replace with your icon path
                  //     const SizedBox(width: 10),
                  //     _buildPlatformIcon('YouTube', 'assets/social_icons/youtube.png'), // Replace with your icon path
                  //   ],
                  // ),
                  // const SizedBox(height: 16),

                  // Search Bar
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  //   child: Container(
                  //     height: 48,
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xFFFFE3E3),
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: TextField(
                  //       onChanged: (value) => setState(() => searchQuery = value),
                  //       decoration: InputDecoration(
                  //         hintText: 'Search',
                  //         border: InputBorder.none,
                  //         contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 16),

                  // Horizontal Tag Scroll
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: tags.length,
                      itemBuilder: (context, index) {
                        String tag = tags[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            onTap: () => setState(() => selectedTag = tag),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: selectedTag == tag ? primary_red : Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                                color: selectedTag == tag ? primary_red.withOpacity(0.2) : Colors.white,
                              ),
                              child: Text(tag, style: TextStyle(color: selectedTag == tag ? primary_red : Colors.black)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Posts List
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = filteredPosts[index];
                        return Stack(
                          children: [
                            SocialPostCard(post: post),
                            if (isNewPost(post.dateTime))
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'New Post',
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator()); // Default loading state
          },
        ),
      ),
    );
  }

  Widget _buildPlatformIcon(String platform, String iconPath) {
    return GestureDetector(
      onTap: () => setState(() => selectedPlatform = platform),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Outer padding for the entire container
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: selectedPlatform == platform ? primary_red : Colors.transparent, // Red border for selected platform
              width: 3, // Border width
            ),
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
            child: Padding(
              padding: const EdgeInsets.all(12.0), // Inner padding for the icon
              child: Image.asset(
                iconPath,
                fit: BoxFit.cover,
                width: 32,
                height: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }
}