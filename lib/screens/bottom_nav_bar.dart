import 'package:flutter/material.dart';
import 'package:movie_app/screens/mainpage/main_page.dart';
import 'package:movie_app/screens/profilepage/profile_page.dart';
import 'package:movie_app/screens/searchpage/search_movie.dart';
import 'package:movie_app/screens/watclistAndWatchedPages/wacthlist.dart';
import 'package:movie_app/screens/watclistAndWatchedPages/watched.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = [
    MainPage(),
    SearchMovie(),
    WatchList(),
    WatchedPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: "Search",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.live_tv_sharp,
              ),
              label: "Watchlist"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.remove_red_eye_outlined,
              ),
              label: "Watched"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
              ),
              label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
