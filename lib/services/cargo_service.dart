import 'package:dio/dio.dart';
import '../models/gerbong_model.dart';
import '../models/barang_model.dart';
import 'api_service.dart';

class CargoService {
  final ApiService _apiService = ApiService();

  // === CRUD GERBONG ===
  Future<List<GerbongModel>> getGerbongs() async {
    try {
      print('🚀 CargoService.getGerbongs() called');
      print('📍 API Base URL: ${_apiService.dio.options.baseUrl}');
      
      final response = await _apiService.dio.get('/gerbongs');
      
      print('✅ Response status: ${response.statusCode}');
      print('📊 Response data: ${response.data}');
      
      final data = response.data['data'] as List;
      return data.map((json) => GerbongModel.fromJson(json)).toList();
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      print('📍 Status Code: ${e.response?.statusCode}');
      print('📋 Response: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil data gerbong');
    }
  }

  Future<GerbongModel> getGerbongById(int id) async {
    try {
      final response = await _apiService.dio.get('/gerbongs/$id');
      return GerbongModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil data gerbong');
    }
  }

  Future<GerbongModel> createGerbong(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.dio.post('/gerbongs', data: data);
      return GerbongModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menambah gerbong');
    }
  }

  Future<GerbongModel> updateGerbong(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.dio.put('/gerbongs/$id', data: data);
      return GerbongModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengupdate gerbong');
    }
  }

  Future<void> deleteGerbong(int id) async {
    try {
      await _apiService.dio.delete('/gerbongs/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menghapus gerbong');
    }
  }

  // === CRUD BARANG KARGO ===
  Future<List<BarangModel>> getBarangKargos() async {
    try {
      final response = await _apiService.dio.get('/barang-kargos');
      final data = response.data['data'] as List;
      return data.map((json) => BarangModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil data kargo');
    }
  }

  Future<List<BarangModel>> getBarangByGerbong(int gerbongId) async {
    try {
      final response = await _apiService.dio.get('/barang-kargos/by-gerbong/$gerbongId');
      final data = response.data['data'] as List;
      return data.map((json) => BarangModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil data kargo');
    }
  }

  Future<List<BarangModel>> getBarangByStatus(String status) async {
    try {
      final response = await _apiService.dio.get('/barang-kargos/by-status/$status');
      final data = response.data['data'] as List;
      return data.map((json) => BarangModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil data kargo');
    }
  }

  Future<BarangModel> createBarang(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.dio.post('/barang-kargos', data: data);
      return BarangModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menambah barang kargo');
    }
  }

  Future<BarangModel> updateBarang(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.dio.put('/barang-kargos/$id', data: data);
      return BarangModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengupdate barang kargo');
    }
  }

  Future<void> deleteBarang(int id) async {
    try {
      await _apiService.dio.delete('/barang-kargos/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menghapus barang kargo');
    }
  }
}
