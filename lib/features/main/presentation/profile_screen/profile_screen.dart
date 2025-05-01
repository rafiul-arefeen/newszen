import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';
import 'package:news_zen/features/main/presentation/edit_profile_screen/edit_profile_screen.dart';
import 'package:news_zen/features/main/presentation/saved_screen/saved_screen.dart';
import 'package:news_zen/features/main/presentation/preferred_tags_screen/preferred_tags_screen.dart';
import 'package:news_zen/features/main/presentation/notifications_screen/notifications_screen.dart';
import 'package:news_zen/features/main/presentation/login_form/login_form_screen.dart';
import 'package:news_zen/features/main/presentation/login_form/bloc/login_cubit.dart';
import 'package:news_zen/features/weather/presentation/widgets/weather_widget.dart';
import 'package:news_zen/features/weather/presentation/screens/detailed_weather_screen.dart';

import '../../../../core/utils/pref_utils.dart';
import '../../../../core/widgets/custom_appbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Fetch username and email from PrefUtils
  Future<Map<String, String?>> _loadUserData() async {
    final email = await PrefUtils.getEmail();
    final username = await PrefUtils.getUserName();
    return {'email': email, 'username': username};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder<Map<String, String?>>(
                future: _loadUserData(), // Fetch data from PrefUtils
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while fetching data
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Handle errors
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!['username'] == null ||
                      snapshot.data!['email'] == null) {
                    // Handle case where data is not available
                    return const Center(
                      child: Text(
                        'No data found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  } else {
                    // Display the fetched data
                    final username = snapshot.data!['username']!;
                    final email = snapshot.data!['email']!;

                    return Column(
                      children: [
                        // Profile Picture and Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage:
                              AssetImage(AppAssets.image.img_user_profile),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    username, // Display the username
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    email, // Display the email
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            // Weather Widget
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: WeatherWidget(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailedWeatherScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Menu Items
            _buildMenuItem(
              icon: Icons.edit,
              title: 'Edit Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.bookmark,
              title: 'Saved',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SavedScreen(),
                  ),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.tag,
              title: 'Preferred Tags',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PreferredTagsScreen(),
                  ),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              isLogout: true,
              onTap: () {
                BlocProvider.of<LoginCubit>(context).logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? primary_red : Colors.black54,
              size: 24,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isLogout ? primary_red : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}