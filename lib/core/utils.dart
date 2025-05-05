// lib/core/network.dart
import 'package:dio/dio.dart';
import 'constants.dart';

class NetworkService {
  final Dio _dio;

  NetworkService() : _dio = Dio(BaseOptions(baseUrl: Constants.baseUrl));

  Future<Response> get(String path) async {
    try {
      final response = await _dio.get(path);
      return response;
    } catch (e) {
      throw Exception('Network error');
    }
  }

  Future<Response> post(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      throw Exception('Network error');
    }
  }
}
