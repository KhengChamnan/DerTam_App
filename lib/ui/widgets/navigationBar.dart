// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tourism_app/theme/theme.dart';
import 'package:tourism_app/ui/screens/favorite/favorite_screen.dart';
import 'package:tourism_app/ui/screens/home/home_page.dart';
import 'package:tourism_app/ui/screens/profiles/profile_screen.dart';
import 'package:tourism_app/ui/screens/trip/trips_screen.dart';

class Navigationbar extends StatelessWidget {
  const Navigationbar({super.key, this.currentIndex = 0});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DertamColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: NavigationBar(
        height: 70,
        elevation: 0,
        selectedIndex: currentIndex,
        backgroundColor: Colors.white,
        indicatorColor: DertamColors.primary.withOpacity(
            0.1), // Change indicator color from purple to light blue
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: Icon(Iconsax.home,
                color: currentIndex == 0 ? Colors.blue : Colors.grey),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.folder,
                color: currentIndex == 1 ? Colors.blue : Colors.grey),
            label: 'Trip Plan',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.heart,
                color: currentIndex == 2 ? Colors.blue : Colors.grey),
            label: 'Favorite',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.user,
                color: currentIndex == 3 ? Colors.blue : Colors.grey),
            label: 'Profile',
          )
        ],
        onDestinationSelected: (int index) {
          if (index == currentIndex) return;

          switch (index) {
            case 0:
              if (currentIndex != 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TripsScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              break;
          }
        },
      ),
    );
  }
}
