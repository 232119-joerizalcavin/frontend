import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // Fungsi Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        final String token = data['data']['access_token'];
        final user = data['data']['user'];

        // Simpan token JWT ke local storage HP
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        await prefs.setString('user_email', user['email']);
        await prefs.setString('user_name', user['name']);

        return data;
      } else {
        throw Exception('Gagal Login ke Sistem');
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Terjadi kesalahan jaringan';
      throw Exception(message);
    }
  }

  // Fungsi Register
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await _apiService.dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Gagal mendaftar');
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Terjadi kesalahan jaringan';
      throw Exception(message);
    }
  }

  // Fungsi Logout
  Future<void> logout() async {
    try {
      print('🔐 Calling /auth/logout endpoint...');
      final response = await _apiService.dio.post('/auth/logout');
      print('✅ Logout response: ${response.data}');
    } catch (e) {
      print('⚠️ Logout API error: $e');
      // Lanjutkan clear token meskipun API gagal
      // karena yang penting adalah token dihapus dari client
    } finally {
      // SELALU hapus token dari HP meskipun API gagal/berhasil
      // Ini memastikan user tetap keluar di frontend
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');
      await prefs.remove('user_email');
      await prefs.remove('user_name');
      print('✅ Local tokens cleared from SharedPreferences');
    }
  }

  // Cek apakah user masih login saat aplikasi dibuka kembali
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('jwt_token');
  }

  // Get stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Get user email
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }
}
