class NewsArticle {
  final String id;
  final String title;
  final String summary;
  final String imageUrl;
  final String source;
  final DateTime publishedAt;
  final String content;

  NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
    required this.content,
  });
}
