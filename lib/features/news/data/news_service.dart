import 'package:dio/dio.dart';
import '../model/news_article.dart';

class NewsService {

  Future<FinancialNews> fetchFinancialNews() async {
    try {
      final response = await Dio().get(
        'https://finnhub.io/api/v1/news',
        queryParameters: {
          'token':
              'd0c78m1r01qs9fjl1s00d0c78m1r01qs9fjl1s0g',
        },
      );

      if (response.statusCode == 200) {
        return FinancialNews.fromJson(response.data);
      } else {
        throw Exception('Failed to load financial news');
      }
    } catch (e) {
      
      throw Exception('Error fetching news');
    }
  }
}
