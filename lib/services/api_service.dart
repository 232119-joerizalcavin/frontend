import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';
  
  final Dio _dio = Dio();
  
  ApiService() {
    _initDio();
  }

  Dio get dio => _dio;

  void _initDio() {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    );

    // Custom interceptor untuk menambahkan token
    _dio.interceptors.add(_TokenInterceptor());
    
    // Error interceptor untuk logging
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          print('❌ Dio Error: ${error.message}');
          print('📍 Status: ${error.response?.statusCode}');
          print('📋 Data: ${error.response?.data}');
          return handler.next(error);
        },
      ),
    );
  }
}

class _TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      
      if (token != null && token.isNotEmpty) {
        print('🎫 Adding token to request: ${token.substring(0, 20)}...');
        options.headers['Authorization'] = 'Bearer $token';
      } else {
        print('⚠️  No token found in SharedPreferences');
      }
    } catch (e) {
      print('❌ Error getting token: $e');
    }
    
    super.onRequest(options, handler);
  }
}
