import 'package:flutter/material.dart';

import '../../features/main/presentation/notifications_screen/notifications_screen.dart';
import '../theme/colors.dart';
import '../utils/app_assets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  void _showNotificationScreen(BuildContext context) {
    // Handle notification button press
    print('Notification button pressed');
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: main_background_colour,
        title: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset(
                    AppAssets.image.img_med_logo,
                    width: 140,
                  ),
                ),
                IconButton(
                  onPressed: () {showNotificationScreen(context);
                  },
                  icon: Icon(Icons.notifications, color: Colors.grey),
                  iconSize: 32,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80); // Set the preferred height
}