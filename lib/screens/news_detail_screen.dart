import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';
import '../models/news_article.dart';
import '../widgets/animations.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final colors = themeProvider.getGradientColors();

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // App Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        FadeInSlide(
                          delay: 0.1,
                          beginOffset: const Offset(-0.2, 0),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: themeProvider.getTextColor()),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const Spacer(),
                        FadeInSlide(
                          delay: 0.1,
                          beginOffset: const Offset(0.2, 0),
                          child: IconButton(
                            icon: Icon(Icons.share, color: themeProvider.getTextColor()),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Sharing not implemented yet')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'news_image_${article.imageUrl}',
                            child: Image.network(
                              article.imageUrl,
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 250,
                                  color: themeProvider.getAccentColor().withOpacity(0.2),
                                  child: Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 64,
                                      color: themeProvider.getSecondaryTextColor(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FadeInSlide(
                                  delay: 0.1,
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: themeProvider.getAccentColor().withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: themeProvider.getAccentColor().withOpacity(0.3)),
                                        ),
                                        child: Text(
                                          article.source,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: themeProvider.getAccentColor(),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: themeProvider.getSecondaryTextColor(),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${(article.content.length / 200).ceil()} min read',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: themeProvider.getSecondaryTextColor(),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        DateFormat.yMMMd().format(article.publishedAt),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: themeProvider.getSecondaryTextColor(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                FadeInSlide(
                                  delay: 0.2,
                                  child: Text(
                                    article.title,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.getTextColor(),
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                FadeInSlide(
                                  delay: 0.3,
                                  child: Text(
                                    article.content, // In a real app, this would be longer
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: themeProvider.getTextColor().withOpacity(0.9),
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                FadeInSlide(
                                  delay: 0.4,
                                  child: Text(
                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: themeProvider.getTextColor().withOpacity(0.9),
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
