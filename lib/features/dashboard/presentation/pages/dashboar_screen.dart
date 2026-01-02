import 'package:flutter/material.dart';
import 'package:smartnews_v2/features/dashboard/presentation/pages/bottomnavbar/bookmark_screen.dart';
import 'package:smartnews_v2/features/dashboard/presentation/pages/bottomnavbar/home_screen.dart';
import 'package:smartnews_v2/features/dashboard/presentation/pages/bottomnavbar/categories_screen.dart';
import 'package:smartnews_v2/features/dashboard/presentation/pages/bottomnavbar/profile_screen.dart';

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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF4A7CFF),

        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),

        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 LOGO
            Image.asset('assets/images/logo.png', height: 36),
            const SizedBox(width: 8),

            // 🔹 TITLE TEXT (MATCH LOGO)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Smart",
                        style: TextStyle(
                          color: Color(0xFF0B2C4D), // Dark Blue
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "News",
                        style: TextStyle(
                          color: Color(0xFFF57C00), // Orange
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  "NEPAL",
                  style: TextStyle(
                    color: Color(0xFF0B2C4D),
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              // TODO: Notification screen
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
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
