import 'package:flutter/material.dart';
import '../../models/gerbong_model.dart';
import '../../models/barang_model.dart';
import '../../services/cargo_service.dart';
import '../../shared/theme.dart';
import 'edit_gerbong_page.dart';

class GerbongDetailPage extends StatefulWidget {
  final GerbongModel gerbong;

  const GerbongDetailPage({
    super.key,
    required this.gerbong,
  });

  @override
  State<GerbongDetailPage> createState() => _GerbongDetailPageState();
}

class _GerbongDetailPageState extends State<GerbongDetailPage> {
  final CargoService _cargoService = CargoService();
  late Future<List<BarangModel>> _barangFuture;

  @override
  void initState() {
    super.initState();
    _barangFuture = _cargoService.getBarangByGerbong(widget.gerbong.id);
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Gerbong'),
        content: Text('Apakah Anda yakin ingin menghapus gerbong ${widget.gerbong.kodeGerbong}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _cargoService.deleteGerbong(widget.gerbong.id);
                if (mounted) {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Close detail page
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Gerbong berhasil dihapus!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CargoTheme.background,
      appBar: AppBar(
        backgroundColor: CargoTheme.primary,
        title: const Text(
          'Detail Gerbong',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditGerbongPage(gerbong: widget.gerbong),
                ),
              ).then((_) {
                // Refresh page setelah edit
                setState(() {
                  _barangFuture = _cargoService.getBarangByGerbong(widget.gerbong.id);
                });
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_rounded, color: Colors.white),
            onPressed: _showDeleteDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Gerbong Info
            Container(
              color: CargoTheme.primary,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_railway_filled_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.gerbong.kodeGerbong,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.gerbong.jenisGerbong,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Kapasitas Maksimal',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.gerbong.kapasitasMaks} Ton',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              'Status',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.gerbong.status ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Detail Gerbong Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Gerbong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: CargoTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailCard(
                    'Kode Gerbong',
                    widget.gerbong.kodeGerbong,
                    Icons.qr_code_rounded,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    'Jenis Gerbong',
                    widget.gerbong.jenisGerbong,
                    Icons.description_rounded,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    'Kapasitas Maksimal',
                    '${widget.gerbong.kapasitasMaks} Ton',
                    Icons.scale_rounded,
                  ),
                  if (widget.gerbong.nomorSeri != null) ...[
                    const SizedBox(height: 12),
                    _buildDetailCard(
                      'Nomor Seri',
                      widget.gerbong.nomorSeri!,
                      Icons.fingerprint_rounded,
                    ),
                  ],
                  if (widget.gerbong.lokasi != null) ...[
                    const SizedBox(height: 12),
                    _buildDetailCard(
                      'Lokasi',
                      widget.gerbong.lokasi!,
                      Icons.location_on_rounded,
                    ),
                  ],
                  if (widget.gerbong.tanggalPembuatan != null) ...[
                    const SizedBox(height: 12),
                    _buildDetailCard(
                      'Tanggal Pembuatan',
                      widget.gerbong.tanggalPembuatan!,
                      Icons.calendar_today_rounded,
                    ),
                  ],
                  if (widget.gerbong.status != null) ...[
                    const SizedBox(height: 12),
                    _buildDetailCard(
                      'Status',
                      widget.gerbong.status!,
                      Icons.info_rounded,
                    ),
                  ],
                  if (widget.gerbong.kondisi != null) ...[
                    const SizedBox(height: 12),
                    _buildDetailCard(
                      'Kondisi',
                      widget.gerbong.kondisi!,
                      Icons.health_and_safety_rounded,
                    ),
                  ],
                ],
              ),
            ),

            // Muatan Barang Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Muatan Barang',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: CargoTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<BarangModel>>(
                    future: _barangFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: CargoTheme.primary,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error: ${snapshot.error}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.inbox_rounded,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tidak ada muatan barang',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final barangList = snapshot.data!;
                      int totalBerat = 0;
                      for (var barang in barangList) {
                        totalBerat += barang.beratMuatan;
                      }

                      return Column(
                        children: [
                          // Summary
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: CargoTheme.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: CargoTheme.secondary.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      'Total Muatan',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$totalBerat Ton',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: CargoTheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Jumlah Item',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${barangList.length}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: CargoTheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Kapasitas Terpakai',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${(totalBerat / widget.gerbong.kapasitasMaks * 100).toStringAsFixed(0)}%',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: totalBerat >
                                                widget.gerbong.kapasitasMaks
                                            ? Colors.red
                                            : CargoTheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // List Barang
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: barangList.length,
                            itemBuilder: (context, index) {
                              final barang = barangList[index];
                              return _BarangCard(barang: barang);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: CargoTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: CargoTheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BarangCard extends StatelessWidget {
  final BarangModel barang;

  const _BarangCard({required this.barang});

  Color _getStatusColor() {
    switch (barang.status) {
      case 'Siap Berangkat':
        return Colors.green;
      case 'Perjalanan':
        return Colors.blue;
      case 'Bongkar':
        return Colors.orange;
      case 'Kosong':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (barang.status) {
      case 'Siap Berangkat':
        return Icons.check_circle_rounded;
      case 'Perjalanan':
        return Icons.local_shipping_rounded;
      case 'Bongkar':
        return Icons.inventory_2_rounded;
      case 'Kosong':
        return Icons.inbox_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      barang.namaBarang,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Klien: ${barang.namaKlien}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getStatusIcon(),
                  color: _getStatusColor(),
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: const Color(0xFFE2E8F0),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Berat Muatan',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${barang.beratMuatan} Ton',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: CargoTheme.primary,
                    ),
                  ),
                ],
              ),
              Chip(
                label: Text(
                  barang.status,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: _getStatusColor(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
