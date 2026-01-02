import 'package:flutter/material.dart';

class CategoriesTab extends StatelessWidget {
  const CategoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {"title": "National", "icon": Icons.flag},
      {"title": "Politics", "icon": Icons.account_balance},
      {"title": "Province News", "icon": Icons.map},
      {"title": "Economy", "icon": Icons.trending_up},
      {"title": "Sports", "icon": Icons.sports_cricket},
      {"title": "Technology", "icon": Icons.memory},
      {"title": "Education", "icon": Icons.school},
      {"title": "Health", "icon": Icons.local_hospital},
      {"title": "Tourism", "icon": Icons.landscape},
      {"title": "Entertainment", "icon": Icons.movie},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];

        return GestureDetector(
          onTap: () {
            // TODO: Navigate to category news list
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0B2C4D), // Dark blue
                  Color(0xFF4A7CFF), // Brand blue
                ],
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
                Icon(category["icon"], size: 40, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  category["title"],
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
