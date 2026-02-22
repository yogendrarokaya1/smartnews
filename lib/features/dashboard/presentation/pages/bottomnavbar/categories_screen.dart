import 'package:flutter/material.dart';
import 'package:smartnews/features/dashboard/presentation/pages/category_news_screen.dart';

class CategoriesTab extends StatelessWidget {
  const CategoriesTab({super.key});

  static const List<Map<String, dynamic>> _categories = [
    {"title": "National", "value": "national", "icon": Icons.flag},
    {"title": "Politics", "value": "politics", "icon": Icons.account_balance},
    {"title": "Sports", "value": "sports", "icon": Icons.sports_cricket},
    {"title": "Technology", "value": "technology", "icon": Icons.memory},
    {"title": "Entertainment", "value": "entertainment", "icon": Icons.movie},
    {"title": "Business", "value": "business", "icon": Icons.business_center},
    {"title": "Health", "value": "health", "icon": Icons.local_hospital},
    {"title": "World", "value": "world", "icon": Icons.public},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.1,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    CategoryNewsScreen(category: category['value'] as String),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF0B2C4D), Color(0xFF4A7CFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category['icon'] as IconData,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  category['title'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
