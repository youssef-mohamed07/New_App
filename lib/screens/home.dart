import 'package:flutter/material.dart';
import 'package:news_app/screens/favorites_screen.dart';
import 'package:news_app/screens/about_screen.dart';
import '../components/news_list.dart';
import '../components/category_card.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.themeMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'sports';

  @override
  Widget build(BuildContext context) {
    final isDark = widget.themeMode == ThemeMode.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [Colors.black87, Colors.grey[900]!]
                      : [Colors.blue.shade300, Colors.blue.shade800],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 3),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('assets/icon.jpg'), // ✅ Replace with your logo
                  ),
                  SizedBox(height: 10),
                  Text(
                    'News App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'by Youssef Mohamed',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildDrawerTile(
              icon: Icons.home,
              label: 'Home',
              onTap: () => Navigator.pop(context),
              isDark: isDark,
            ),
            _buildDrawerTile(
              icon: Icons.favorite,
              label: 'Favorites',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                );
              },
              isDark: isDark,
            ),
            _buildDrawerTile(
              icon: Icons.info_outline,
              label: 'About',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
              },
              isDark: isDark,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                '© 2025 Youssef Mohamed',
                style: TextStyle(
                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: isDark ? Colors.black : Colors.white,
        title: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
            children: [
              TextSpan(
                text: 'NEWS',
                style: TextStyle(
                  color: isDark ? Colors.amber : Colors.orange,
                ),
              ),
              const TextSpan(
                text: ' APP',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
            color: isDark ? Colors.white : Colors.black,
            tooltip: "Toggle Theme",
          ),
        ],
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoriesList(
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.category, size: 20, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'Category: ${selectedCategory.toUpperCase()}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: NewsListView(
                key: ValueKey(selectedCategory),
                category: selectedCategory,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDark ? Colors.amber : Colors.blueAccent),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      onTap: onTap,
      horizontalTitleGap: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      hoverColor: isDark ? Colors.grey[800] : Colors.grey[200],
    );
  }
}
