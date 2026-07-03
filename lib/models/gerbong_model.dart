class GerbongModel {
  final int id;
  final String kodeGerbong;
  final String jenisGerbong;
  final int kapasitasMaks;
  final String status;
  final String? lokasi;
  final String? nomorSeri;
  final String? tanggalPembuatan;
  final String? kondisi;

  GerbongModel({
    required this.id,
    required this.kodeGerbong,
    required this.jenisGerbong,
    required this.kapasitasMaks,
    required this.status,
    this.lokasi,
    this.nomorSeri,
    this.tanggalPembuatan,
    this.kondisi,
  });

  // Mengubah JSON dari Laravel menjadi Objek Dart
  factory GerbongModel.fromJson(Map<String, dynamic> json) {
    return GerbongModel(
      id: json['id'],
      kodeGerbong: json['kode_gerbong'],
      jenisGerbong: json['jenis_gerbong'],
      kapasitasMaks: json['kapasitas_maks'],
      status: json['status'] ?? 'Aktif',
      lokasi: json['lokasi'],
      nomorSeri: json['nomor_seri'],
      tanggalPembuatan: json['tanggal_pembuatan'],
      kondisi: json['kondisi'] ?? 'Baik',
    );
  }

  // Mengubah Objek Dart ke JSON untuk keperluan POST/PUT ke API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode_gerbong': kodeGerbong,
      'jenis_gerbong': jenisGerbong,
      'kapasitas_maks': kapasitasMaks,
      'status': status,
      'lokasi': lokasi,
      'nomor_seri': nomorSeri,
      'tanggal_pembuatan': tanggalPembuatan,
      'kondisi': kondisi,
    };
  }
}