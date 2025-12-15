import '../models/news_article.dart';

class NewsService {
  Future<List<NewsArticle>> getNews() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      NewsArticle(
        id: '1',
        title: 'USD Strengthens Amid Global Uncertainty',
        summary: 'The US Dollar continues to rally as investors seek safe havens.',
        imageUrl: 'https://images.unsplash.com/photo-1580519542036-c47de6196ba5?auto=format&fit=crop&q=80&w=1000',
        source: 'Financial Times',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        content: 'The US Dollar Index (DXY) rose 0.5% today as global markets reacted to...',
      ),
      NewsArticle(
        id: '2',
        title: 'Euro Dips Following ECB Announcement',
        summary: 'European Central Bank signals potential rate cuts in the coming quarter.',
        imageUrl: 'https://images.unsplash.com/photo-1621981386829-9b788a817886?auto=format&fit=crop&q=80&w=1000',
        source: 'Bloomberg',
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        content: 'The Euro fell against major peers after the ECB President hinted at...',
      ),
      NewsArticle(
        id: '3',
        title: 'Crypto Markets See Volatility',
        summary: 'Bitcoin and Ethereum experience sharp swings ahead of regulatory news.',
        imageUrl: 'https://images.unsplash.com/photo-1518546305927-5a555bb7020d?auto=format&fit=crop&q=80&w=1000',
        source: 'CoinDesk',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        content: 'Cryptocurrency markets were volatile today as traders awaited...',
      ),
      NewsArticle(
        id: '4',
        title: 'Yen Stabilizes After Government Intervention',
        summary: 'Japanese authorities stepped in to support the currency after recent lows.',
        imageUrl: 'https://images.unsplash.com/photo-1526304640152-d4619684e484?auto=format&fit=crop&q=80&w=1000',
        source: 'Reuters',
        publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        content: 'The Japanese Yen recovered some ground today following suspected intervention...',
      ),
    ];
  }
}
