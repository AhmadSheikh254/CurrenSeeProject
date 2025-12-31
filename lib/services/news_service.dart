import '../models/news_article.dart';

class NewsService {
  Future<List<NewsArticle>> getNews({String category = 'All'}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final allNews = [
      NewsArticle(
        id: '1',
        title: 'USD Strengthens Amid Global Uncertainty',
        summary: 'The US Dollar continues to rally as investors seek safe havens.',
        imageUrl: 'https://images.unsplash.com/photo-1580519542036-c47de6196ba5?auto=format&fit=crop&q=80&w=1000',
        source: 'Financial Times',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        content: 'The US Dollar Index (DXY) rose 0.5% today as global markets reacted to...',
        category: 'Forex',
      ),
      NewsArticle(
        id: '2',
        title: 'Euro Dips Following ECB Announcement',
        summary: 'European Central Bank signals potential rate cuts in the coming quarter.',
        imageUrl: 'https://images.unsplash.com/photo-1591033594798-33227a05780d?auto=format&fit=crop&q=80&w=1000',
        source: 'Bloomberg',
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        content: 'The Euro fell against major peers after the ECB President hinted at...',
        category: 'Forex',
      ),
      NewsArticle(
        id: '3',
        title: 'Bitcoin Hits New Monthly High',
        summary: 'The leading cryptocurrency surges past resistance levels as institutional interest grows.',
        imageUrl: 'https://images.unsplash.com/photo-1518546305927-5a555bb7020d?auto=format&fit=crop&q=80&w=1000',
        source: 'CoinDesk',
        publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        content: 'Bitcoin (BTC) has shown remarkable strength today, breaking through...',
        category: 'Crypto',
      ),
      NewsArticle(
        id: '4',
        title: 'Ethereum 2.0 Upgrade Progresses',
        summary: 'Developers report successful testnet merge, bringing the network closer to PoS.',
        imageUrl: 'https://images.unsplash.com/photo-1622790698141-94e30457ef12?auto=format&fit=crop&q=80&w=1000',
        source: 'CryptoNews',
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
        content: 'The Ethereum community is celebrating another milestone as...',
        category: 'Crypto',
      ),
      NewsArticle(
        id: '5',
        title: 'Tech Stocks Rally on AI Optimism',
        summary: 'Major technology companies see share prices climb following strong earnings reports.',
        imageUrl: 'https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?auto=format&fit=crop&q=80&w=1000',
        source: 'Wall Street Journal',
        publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
        content: 'The Nasdaq Composite gained 1.2% today, led by gains in...',
        category: 'Stocks',
      ),
      NewsArticle(
        id: '6',
        title: 'Global Markets Brace for Inflation Data',
        summary: 'Investors are cautious ahead of key CPI releases from major economies.',
        imageUrl: 'https://images.unsplash.com/photo-1621451537084-482c73073a0f?auto=format&fit=crop&q=80&w=1000',
        source: 'Reuters',
        publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
        content: 'Market participants are closely watching the upcoming inflation reports...',
        category: 'Economy',
      ),
      NewsArticle(
        id: '7',
        title: 'Oil Prices Stabilize After Recent Drop',
        summary: 'Crude oil futures hold steady as supply concerns balance demand worries.',
        imageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&q=80&w=1000',
        source: 'CNBC',
        publishedAt: DateTime.now().subtract(const Duration(hours: 15)),
        content: 'Brent crude was trading near \$85 a barrel today as...',
        category: 'Economy',
      ),
      NewsArticle(
        id: '8',
        title: 'Solana Ecosystem Sees Rapid Growth',
        summary: 'New DeFi projects and NFT collections drive increased activity on the Solana blockchain.',
        imageUrl: 'https://images.unsplash.com/photo-1639762681485-074b7f938ba0?auto=format&fit=crop&q=80&w=1000',
        source: 'Decrypt',
        publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
        content: 'The Solana network has seen a surge in unique active wallets...',
        category: 'Crypto',
      ),
    ];

    if (category == 'All') {
      return allNews;
    } else {
      return allNews.where((article) => article.category == category).toList();
    }
  }
}
