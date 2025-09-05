import 'package:evently_c15/ui/screens/home/tabs/favorite/favorite_tab.dart';
import 'package:evently_c15/ui/screens/home/tabs/home/home_tab.dart';
import 'package:evently_c15/ui/screens/home/tabs/map/map_tab.dart';
import 'package:evently_c15/ui/screens/home/tabs/profile/profile_tab.dart';
import 'package:evently_c15/ui/utils/app_assets.dart';
import 'package:evently_c15/ui/utils/app_colors.dart';
import 'package:evently_c15/ui/utils/app_routes.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  List<Widget> tabs = [
    const HomeTab(),
    const MapTab(),
    const FavoriteTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: tabs[currentIndex],
        floatingActionButton: buildFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: buildBottomAppBar(),
      ),
    );
  }


  buildBottomAppBar() => BottomAppBar(
    shape: const CircularNotchedRectangle(),
    notchMargin: 8,
    color: AppColors.blue,
    elevation: 0,
    child: SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNavItem(0, currentIndex == 0 ? AppAssets.homeActive : AppAssets.icHome, "home"),
          buildNavItem(1, currentIndex == 1 ? AppAssets.mapActive : AppAssets.icMap, "map"),
          const SizedBox(width: 40), // ⬅️ مساحة للـ FAB
          buildNavItem(2, currentIndex == 2 ? AppAssets.loveActive : AppAssets.icFavorite, "favorite"),
          buildNavItem(3, currentIndex == 3 ? AppAssets.profileActive : AppAssets.icProfile, "profile"),
        ],
      ),
    ),
  );


  Widget buildNavItem(int index, String assetPath, String label) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageIcon(
            AssetImage(assetPath),
            color: Colors.white,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }


  buildFab() => FloatingActionButton(
    backgroundColor: AppColors.blue,
    shape: const CircleBorder(),
    onPressed: () {
      Navigator.push(context, AppRoutes.addEvent);
    },
    child: const Icon(Icons.add, size: 32, color: Colors.white),
  );
}
