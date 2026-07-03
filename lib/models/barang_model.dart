class BarangModel {
  final int id;
  final int gerbongId;
  final String namaBarang;
  final String namaKlien;
  final int beratMuatan;
  final String status;

  BarangModel({
    required this.id,
    required this.gerbongId,
    required this.namaBarang,
    required this.namaKlien,
    required this.beratMuatan,
    required this.status,
  });

  // Mengubah JSON dari Laravel menjadi Objek Dart
  factory BarangModel.fromJson(Map<String, dynamic> json) {
    return BarangModel(
      id: json['id'],
      gerbongId: json['gerbong_id'],
      namaBarang: json['nama_barang'],
      namaKlien: json['nama_klien'],
      beratMuatan: json['berat_muatan'],
      status: json['status'],
    );
  }

  // Mengubah Objek Dart ke JSON untuk keperluan POST/PUT ke API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gerbong_id': gerbongId,
      'nama_barang': namaBarang,
      'nama_klien': namaKlien,
      'berat_muatan': beratMuatan,
      'status': status,
    };
  }
}