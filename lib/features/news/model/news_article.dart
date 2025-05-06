class FinancialNews {
  final List<Article> articles;

  FinancialNews({required this.articles});

  factory FinancialNews.fromJson(List<dynamic> json) {
    return FinancialNews(
      articles:
          json.map((articleJson) => Article.fromJson(articleJson)).toList(),
    );
  }
}

class Article {
  final String headline;
  final String source;
  final String url;
  final String image;
  final String datetime;

  Article({
    required this.headline,
    required this.source,
    required this.url,
    required this.image,
    required this.datetime,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      headline: json['headline'] ?? '',
      source: json['source'] ?? '',
      url: json['url'] ?? '',
      image: json['image'] ?? '',
      datetime:
          DateTime.fromMillisecondsSinceEpoch(
            json['datetime'] * 1000,
          ).toString(),
    );
  }
}
