import 'package:flutter/material.dart';
import 'package:news_zen/features/main/presentation/ai_screen/ai_screen.dart';
import 'package:news_zen/features/main/presentation/explore_screen/explore_screen.dart';
import 'package:news_zen/features/main/presentation/home_screen/home_screen.dart';
import 'package:news_zen/features/main/presentation/profile_screen/profile_screen.dart';
import 'package:news_zen/features/main/presentation/socials_screen/socials_screen.dart';

class MainBottomBar extends StatefulWidget {
  const MainBottomBar({super.key});

  @override
  State<MainBottomBar> createState() => _MainBottomBarState();
}

class _MainBottomBarState extends State<MainBottomBar> {
  late PageController _pageController;
  int _selectedIndex = 0;

  final List<BottomMenuModel> _bottomMenuList = [
    BottomMenuModel(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      body: const HomeScreen(),
    ),
    BottomMenuModel(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore,
      body: const ExploreScreen(),
    ),
    BottomMenuModel(
      icon: Icons.window_outlined,
      activeIcon: Icons.window,
      body: const SocialsPage(),
    ),
    BottomMenuModel(
      icon: Icons.chat_outlined,
      activeIcon: Icons.chat,
      body: const AIChatScreen(),
    ),
    BottomMenuModel(
      icon: Icons.person_outlined,
      activeIcon: Icons.person,
      body: const ProfileScreen(),
    ),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: _selectedIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color
            blurRadius: 10, // Spread of the shadow
            offset: const Offset(0, -5), // Shadow position (top)
          ),
        ],
      ),
      child: Row(
        children: _bottomMenuList.map((menu) {
          final index = _bottomMenuList.indexOf(menu);
          return _buildBottomNavItem(
            index: index,
            selectedIcon: menu.activeIcon,
            unSelectedIcon: menu.icon,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required int index,
    required IconData selectedIcon,
    required IconData unSelectedIcon,
  }) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isSelected ? selectedIcon : unSelectedIcon,
                key: ValueKey(isSelected),
                color: isSelected ? Colors.red : Colors.grey,
                size: 28,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 6,
                width: 6,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _bottomMenuList.map((menu) => menu.body).toList(),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }
}

class BottomMenuModel {
  final IconData icon;
  final IconData activeIcon;
  final Widget body;

  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    required this.body,
  });
}
