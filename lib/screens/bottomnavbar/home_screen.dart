import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Recent News Section
          _sectionTitle("Recent News"),
          _recentNewsCard(),
          _recentNewsCard(),

          // Sports Section
          _sectionTitle("Sports", seeMore: true),
          _smallNewsCard("Quatar Stadium Coming Along For Last Stretch"),
          _smallNewsCard("Preparation for Nepalgunj Marathon Completed"),
          _smallNewsCard("Netherlands Qualifies For World Cup"),

          // International Section
          _sectionTitle("International", seeMore: true),
          _smallNewsCard(
            "Pakistan on the list of countries violating religious freedom ...",
          ),
          _smallNewsCard(
            "Indian PM announces withdrawal of all three agricultural laws",
          ),
          _smallNewsCard("5 killed in Sudan anti-military protests"),

          // Trending Section
          _sectionTitle("Trending", seeMore: true),
          _trendingNewsItem(
            "Illegal television inaugurated by the Prime Minister",
          ),
          _trendingNewsItem(
            "That report of Fewatal hidden for almost 32 years",
          ),
          _trendingNewsItem("Cantilever Bridge: Not for walking, just to see"),

          // Provincial News (placeholder map)
          _sectionTitle("Provincial News"),
          Container(
            height: 100,
            color: Colors.grey[300],
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: const Center(child: Text("Map Placeholder")),
          ),

          // Videos Section
          _sectionTitle("Videos"),
          _videoCard(),
        ],
      ),
    );
  }

  // Section title widget
  Widget _sectionTitle(String title, {bool seeMore = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (seeMore)
            const Text("See More", style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }

  // Recent News card
  Widget _recentNewsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 180,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: NetworkImage("https://via.placeholder.com/400x200"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: const [
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Text(
              "Electronic voting in 12 hours, results in four hours",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Small news card for Sports/International
  Widget _smallNewsCard(String title) {
    return ListTile(
      leading: Container(
        width: 100,
        height: 60,
        color: Colors.grey[300],
        child: const Icon(Icons.image, size: 40),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {},
    );
  }

  // Trending news item
  Widget _trendingNewsItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Text(title),
    );
  }

  // Video card
  Widget _videoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 180,
      color: Colors.black,
      child: const Center(
        child: Icon(Icons.play_circle_outline, color: Colors.white, size: 50),
      ),
    );
  }
}
