import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/gerbong/gerbong_bloc.dart';
import '../../blocs/gerbong/gerbong_event.dart';
import '../../blocs/gerbong/gerbong_state.dart';
import '../../models/gerbong_model.dart';
import '../../shared/theme.dart';

class EditGerbongPage extends StatefulWidget {
  final GerbongModel gerbong;

  const EditGerbongPage({
    super.key,
    required this.gerbong,
  });

  @override
  State<EditGerbongPage> createState() => _EditGerbongPageState();
}

class _EditGerbongPageState extends State<EditGerbongPage> {
  late TextEditingController _kodeGerbongController;
  late TextEditingController _jenisGerbongController;
  late TextEditingController _kapasitasController;
  late TextEditingController _nomorSeriController;
  late TextEditingController _lokasiController;
  late TextEditingController _tanggalController;
  final _formKey = GlobalKey<FormState>();

  late String _selectedStatus;
  late String _selectedKondisi;

  @override
  void initState() {
    super.initState();
    _kodeGerbongController = TextEditingController(text: widget.gerbong.kodeGerbong);
    _jenisGerbongController = TextEditingController(text: widget.gerbong.jenisGerbong);
    _kapasitasController = TextEditingController(text: widget.gerbong.kapasitasMaks.toString());
    _nomorSeriController = TextEditingController(text: widget.gerbong.nomorSeri ?? '');
    _lokasiController = TextEditingController(text: widget.gerbong.lokasi ?? '');
    _tanggalController = TextEditingController(text: widget.gerbong.tanggalPembuatan ?? '');
    _selectedStatus = widget.gerbong.status ?? 'Aktif';
    _selectedKondisi = widget.gerbong.kondisi ?? 'Baik';
  }

  @override
  void dispose() {
    _kodeGerbongController.dispose();
    _jenisGerbongController.dispose();
    _kapasitasController.dispose();
    _nomorSeriController.dispose();
    _lokasiController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalController.text.isNotEmpty
          ? DateTime.parse(_tanggalController.text)
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _tanggalController.text = picked.toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CargoTheme.background,
      appBar: AppBar(
        backgroundColor: CargoTheme.primary,
        title: const Text(
          'Edit Gerbong',
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
      ),
      body: BlocListener<GerbongBloc, GerbongState>(
        listener: (context, state) {
          if (state is GerbongLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Gerbong berhasil diperbarui!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is GerbongError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<GerbongBloc, GerbongState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Icon
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: CargoTheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.directions_railway_filled_rounded,
                            size: 60,
                            color: CargoTheme.primary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Kode Gerbong Field
                      _buildLabel('Kode Gerbong'),
                      TextFormField(
                        controller: _kodeGerbongController,
                        enabled: state is! GerbongLoading,
                        decoration: _buildInputDecoration('PPCW-4210', Icons.qr_code_rounded),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kode gerbong harus diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Jenis Gerbong Field
                      _buildLabel('Jenis Gerbong'),
                      TextFormField(
                        controller: _jenisGerbongController,
                        enabled: state is! GerbongLoading,
                        maxLines: 2,
                        decoration: _buildInputDecoration('Gerbong Datar (Flatcar Baja)', Icons.description_rounded),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Jenis gerbong harus diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Kapasitas Maksimal Field
                      _buildLabel('Kapasitas Maksimal (Ton)'),
                      TextFormField(
                        controller: _kapasitasController,
                        enabled: state is! GerbongLoading,
                        keyboardType: TextInputType.number,
                        decoration: _buildInputDecoration('40', Icons.scale_rounded, suffix: 'Ton'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kapasitas harus diisi';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Kapasitas harus berupa angka';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Nomor Seri Field
                      _buildLabel('Nomor Seri'),
                      TextFormField(
                        controller: _nomorSeriController,
                        enabled: state is! GerbongLoading,
                        decoration: _buildInputDecoration('SN-2024-001', Icons.fingerprint_rounded),
                      ),

                      const SizedBox(height: 20),

                      // Lokasi Field
                      _buildLabel('Lokasi'),
                      TextFormField(
                        controller: _lokasiController,
                        enabled: state is! GerbongLoading,
                        decoration: _buildInputDecoration('Depot Jakarta', Icons.location_on_rounded),
                      ),

                      const SizedBox(height: 20),

                      // Tanggal Pembuatan Field
                      _buildLabel('Tanggal Pembuatan'),
                      TextFormField(
                        controller: _tanggalController,
                        enabled: state is! GerbongLoading,
                        readOnly: true,
                        decoration: _buildInputDecoration('YYYY-MM-DD', Icons.calendar_today_rounded),
                        onTap: () => _selectDate(context),
                      ),

                      const SizedBox(height: 20),

                      // Status Dropdown
                      _buildLabel('Status Gerbong'),
                      AbsorbPointer(
                        absorbing: state is GerbongLoading,
                        child: Opacity(
                          opacity: state is GerbongLoading ? 0.5 : 1.0,
                          child: DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            decoration: _buildDropdownDecoration('Pilih Status'),
                            items: ['Aktif', 'Maintenance', 'Pensiun']
                                .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                                .toList(),
                            onChanged: state is GerbongLoading
                                ? null
                                : (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedStatus = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Kondisi Dropdown
                      _buildLabel('Kondisi Gerbong'),
                      AbsorbPointer(
                        absorbing: state is GerbongLoading,
                        child: Opacity(
                          opacity: state is GerbongLoading ? 0.5 : 1.0,
                          child: DropdownButtonFormField<String>(
                            value: _selectedKondisi,
                            decoration: _buildDropdownDecoration('Pilih Kondisi'),
                            items: ['Baik', 'Perlu Perbaikan', 'Rusak']
                                .map((kondisi) => DropdownMenuItem(
                              value: kondisi,
                              child: Text(kondisi),
                            ))
                                .toList(),
                            onChanged: state is GerbongLoading
                                ? null
                                : (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedKondisi = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CargoTheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: state is GerbongLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    final gerbongData = {
                                      'kode_gerbong': _kodeGerbongController.text.trim(),
                                      'jenis_gerbong': _jenisGerbongController.text.trim(),
                                      'kapasitas_maks': int.parse(_kapasitasController.text),
                                      'nomor_seri': _nomorSeriController.text.trim().isEmpty
                                          ? null
                                          : _nomorSeriController.text.trim(),
                                      'lokasi': _lokasiController.text.trim().isEmpty
                                          ? null
                                          : _lokasiController.text.trim(),
                                      'tanggal_pembuatan': _tanggalController.text.isEmpty
                                          ? null
                                          : _tanggalController.text,
                                      'status': _selectedStatus,
                                      'kondisi': _selectedKondisi,
                                    };

                                    print('📤 Updating gerbong ${widget.gerbong.id}: $gerbongData');
                                    context.read<GerbongBloc>().add(UpdateGerbong(widget.gerbong.id, gerbongData));
                                  }
                                },
                          child: state is GerbongLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'PERBARUI GERBONG',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Cancel Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: CargoTheme.primary),
                          ),
                          onPressed: state is GerbongLoading ? null : () => Navigator.pop(context),
                          child: const Text(
                            'BATAL',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: CargoTheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon, {String? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: CargoTheme.primary),
      suffixText: suffix,
      suffixStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CargoTheme.primary, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  InputDecoration _buildDropdownDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.list_rounded, color: CargoTheme.primary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CargoTheme.primary, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
