import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // ================= RECENT NEWS =================
          _sectionTitle("Recent News"),
          _recentNewsCard(
            imagePath: "assets/images/sportnews1.jpeg",
            title: "Electronic voting in 12 hours, results in four hours",
            date: "19th Nov 2021",
          ),
          _recentNewsCard(
            imagePath: "assets/images/sportnews1.jpeg",
            title: "Electronic voting in 12 hours, results in four hours",
            date: "19th Nov 2021",
          ),

          // ================= National Politics =================
          _sectionTitle("National", seeMore: true),
          _smallNewsCard(
            imagePath: "assets/images/sportnews1.jpeg",
            title:
                "Police say 48 arrested for September violence had criminal past",
          ),
          _smallNewsCard(
            imagePath: "assets/images/sportnews1.jpeg",
            title:
                "Police say 48 arrested for September violence had criminal past",
          ),
          _smallNewsCard(
            imagePath: "assets/images/sportnews1.jpeg",
            title:
                "Police say 48 arrested for September violence had criminal past",
          ),

          // ================= SPORTS =================
          _sectionTitle("Sports", seeMore: true),
          _smallNewsCard(
            imagePath: "assets/images/sportnews1.jpeg",
            title: "Quatar Stadium Coming Along For Last Stretch",
          ),
          _smallNewsCard(
            imagePath: "assets/images/sportnews1.jpeg",
            title: "Preparation for Nepalgunj Marathon Completed",
          ),
          _smallNewsCard(
            imagePath: "assets/images/sportnews1.jpeg",
            title: "Netherlands Qualifies For World Cup",
          ),

          // ================= INTERNATIONAL =================
          _sectionTitle("International", seeMore: true),
          _smallNewsCard(
            imagePath: "assets/images/sportnews1.jpeg",
            title:
                "Pakistan on the list of countries violating religious freedom ...",
          ),
          _smallNewsCard(
            imagePath: "assets/images/sportnews1.jpeg",
            title:
                "Indian PM announces withdrawal of all three agricultural laws",
          ),
          _smallNewsCard(
            imagePath: "assets/images/sportnews1.jpeg",
            title: "5 killed in Sudan anti-military protests",
          ),

          // ================= TRENDING =================
          _sectionTitle("Trending", seeMore: true),
          _trendingNewsItem(
            "Illegal television inaugurated by the Prime Minister",
          ),
          _trendingNewsItem(
            "That report of Fewatal hidden for almost 32 years",
          ),
          _trendingNewsItem("Cantilever Bridge: Not for walking, just to see"),

          // ================= VIDEOS =================
          _sectionTitle("Videos"),
          _videoCard(imagePath: "assets/images/sportnews1.jpeg"),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget _sectionTitle(String title, {bool seeMore = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (seeMore)
            const Text("See More", style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }

  // ================= RECENT NEWS CARD =================
  Widget _recentNewsCard({
    required String imagePath,
    required String title,
    required String date,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                date,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= SMALL NEWS CARD =================
  Widget _smallNewsCard({required String imagePath, required String title}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(imagePath, width: 90, height: 60, fit: BoxFit.cover),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      onTap: () {},
    );
  }

  // ================= TRENDING ITEM =================
  Widget _trendingNewsItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(title, style: const TextStyle(fontSize: 14)),
    );
  }

  // ================= VIDEO CARD =================
  Widget _videoCard({required String imagePath}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: const Center(
        child: Icon(Icons.play_circle_outline, color: Colors.white, size: 60),
      ),
    );
  }
}
