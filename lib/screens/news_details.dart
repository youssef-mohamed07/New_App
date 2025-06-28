import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsDetails extends StatelessWidget {
  final Map article;

  const NewsDetails({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = article['title'] ?? 'No Title';
    final description = article['description'] ?? '';
    final content = article['content'] ?? '';
    final imageUrl = article['urlToImage'];

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        elevation: 0,
        title: Text(
          'News Details',
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              if (imageUrl != null && imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 220,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 60),
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Title
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Description
              if (description.isNotEmpty)
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    height: 1.6,
                    color: isDark ? Colors.grey[300] : Colors.grey[800],
                  ),
                ),
              const SizedBox(height: 20),

              // Content
              if (content.isNotEmpty)
                Text(
                  content,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    height: 1.8,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),

              const SizedBox(height: 30),
              // Divider and Footer
              Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
              Center(
                child: Text(
                  '📰 End of Article',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: isDark ? Colors.grey[600] : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
