import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesList extends StatelessWidget {
  final Function(String category) onCategorySelected;

  const CategoriesList({super.key, required this.onCategorySelected});

  final List<Map<String, String>> categories = const [
    {'title': 'general', 'imagePath': 'assets/general.avif'},
    {'title': 'sports', 'imagePath': 'assets/sports.avif'},
    {'title': 'technology', 'imagePath': 'assets/technology.jpeg'},
    {'title': 'health', 'imagePath': 'assets/health.avif'},
    {'title': 'business', 'imagePath': 'assets/business.avif'},
    {'title': 'science', 'imagePath': 'assets/science.avif'},
    {'title': 'entertainment', 'imagePath': 'assets/entertaiment.avif'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final category = categories[index];

          return GestureDetector(
            onTap: () => onCategorySelected(category['title']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: AssetImage(category['imagePath']!),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black45 : Colors.black26,
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    category['title']!.toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      shadows: const [
                        Shadow(
                          blurRadius: 6,
                          color: Colors.black54,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
