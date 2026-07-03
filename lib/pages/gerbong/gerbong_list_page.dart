import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/gerbong/gerbong_bloc.dart';
import '../../blocs/gerbong/gerbong_event.dart';
import '../../blocs/gerbong/gerbong_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../shared/theme.dart';
import '../../widgets/cargo_card.dart';
import '../../models/barang_model.dart';
import '../../services/cargo_service.dart';
import 'add_gerbong_page.dart';

class GerbongListPage extends StatefulWidget {
  const GerbongListPage({super.key});

  @override
  State<GerbongListPage> createState() => _GerbongListPageState();
}

class _GerbongListPageState extends State<GerbongListPage> {
  final CargoService _cargoService = CargoService();

  @override
  void initState() {
    super.initState();
    // Fetch gerbongs ketika halaman dimuat
    context.read<GerbongBloc>().add(FetchGerbongs());
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar Aplikasi'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const LogoutRequested());
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // Hitung total muatan dan statistik
  Future<Map<String, dynamic>> _getStatistics() async {
    try {
      final barangKargos = await _cargoService.getBarangKargos();
      int totalTon = 0;
      for (var barang in barangKargos) {
        totalTon += barang.beratMuatan;
      }
      return {
        'totalGerbong': 0, // Akan diupdate di bloc
        'totalMuatan': totalTon,
        'status': 'OPERASIONAL',
      };
    } catch (e) {
      return {
        'totalGerbong': 0,
        'totalMuatan': 0,
        'status': 'OFFLINE',
      };
    }
  }

  // Hitung berat muatan untuk satu gerbong
  Future<int> _getGerbongLoadWeight(int gerbongId) async {
    try {
      final barang = await _cargoService.getBarangByGerbong(gerbongId);
      int totalBerat = 0;
      for (var item in barang) {
        totalBerat += item.beratMuatan;
      }
      return totalBerat;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print('🔐 GerbongListPage BlocListener - Auth state: ${state.runtimeType}');
        // Jika logout berhasil, navigasi ke login page
        if (state is AuthUnauthenticated) {
          print('✅ AuthUnauthenticated detected, navigating to login...');
          // Gunakan pushReplacementNamed untuk navigate ke /login route
          Navigator.of(context).pushReplacementNamed('/login');
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Berhasil keluar dari aplikasi'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: CargoTheme.background,
        appBar: AppBar(
          backgroundColor: CargoTheme.primary,
          title: const Text(
            "KOMANDO LOGISTIK KA",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.power_settings_new_rounded, color: Colors.redAccent),
              tooltip: 'Keluar',
              onPressed: _showLogoutDialog,
            )
          ],
        ),
      body: BlocBuilder<GerbongBloc, GerbongState>(
        builder: (context, state) {
          if (state is GerbongLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: CargoTheme.primary,
              ),
            );
          } else if (state is GerbongError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GerbongBloc>().add(FetchGerbongs());
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          } else if (state is GerbongLoaded) {
            final gerbongs = state.gerbongs;

            return CustomScrollView(
              slivers: [
                // Banner Dashboard
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: CargoTheme.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: _getStatistics(),
                      builder: (context, snapshot) {
                        final stats = snapshot.data ?? {
                          'totalGerbong': gerbongs.length,
                          'totalMuatan': 0,
                          'status': 'LOADING',
                        };

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: CargoTheme.secondary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _DashboardStat(
                                label: "Gerbong Aktif",
                                value: "${gerbongs.length} Unit",
                              ),
                              _DashboardStat(
                                label: "Total Muatan",
                                value: "${stats['totalMuatan']} Ton",
                              ),
                              _DashboardStat(
                                label: "Status Operasi",
                                value: stats['status'],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // List Gerbong
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Manajemen Inventaris Gerbong",
                                style: CargoTheme.titleStyle,
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }

                        final gerbong = gerbongs[index - 1];

                        return FutureBuilder<int>(
                          future: _getGerbongLoadWeight(gerbong.id),
                          builder: (context, snapshot) {
                            final loadedWeight = snapshot.data ?? 0;

                            return CargoCard(
                              kodeGerbong: gerbong.kodeGerbong,
                              jenisGerbong: gerbong.jenisGerbong,
                              kapasitasTerisi: loadedWeight,
                              kapasitasMaks: gerbong.kapasitasMaks,
                              gerbong: gerbong,
                              onTap: () {},
                            );
                          },
                        );
                      },
                      childCount: gerbongs.length + 1,
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: Text('Tekan tombol untuk memuat data'),
          );
        },
      ),
        // Tombol Tambah Gerbong
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: CargoTheme.accent,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_box_rounded),
          label: const Text(
            "TAMBAH GERBONG",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddGerbongPage()),
            );
          },
        ),
      ),
    );
  }
}

// Widget Statistik Dashboard
class _DashboardStat extends StatelessWidget {
  final String label;
  final String value;

  const _DashboardStat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
