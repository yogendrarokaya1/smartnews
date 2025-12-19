import 'package:flutter/material.dart';

class CategoriesTab extends StatelessWidget {
  const CategoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      children: const [
        Card(child: Center(child: Text("Politics"))),
        Card(child: Center(child: Text("Sports"))),
        Card(child: Center(child: Text("Tech"))),
        Card(child: Center(child: Text("Business"))),
      ],
    );
  }
}
