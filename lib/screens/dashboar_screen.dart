import 'package:flutter/material.dart';
import 'package:smartnews/screens/bottomnavbar/bookmark_screen.dart';
import 'package:smartnews/screens/bottomnavbar/categories_screen.dart';
import 'package:smartnews/screens/bottomnavbar/home_screen.dart';
import 'package:smartnews/screens/bottomnavbar/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeTab(),
    CategoriesTab(),
    BookmarksTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SmartNews Nepal")),

      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF4A7CFF)),
              child: Text(
                "SmartNews Nepal",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text("Home")),
            ListTile(leading: Icon(Icons.category), title: Text("Categories")),
            ListTile(leading: Icon(Icons.bookmark), title: Text("Bookmarks")),
            ListTile(leading: Icon(Icons.person), title: Text("Profile")),
          ],
        ),
      ),

      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Bookmarks",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
