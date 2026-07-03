import 'package:flutter/material.dart';
import '../shared/theme.dart';
import '../models/gerbong_model.dart';
import '../pages/gerbong/gerbong_detail_page.dart';

class CargoCard extends StatelessWidget {
  final String kodeGerbong;
  final String jenisGerbong;
  final int kapasitasTerisi;
  final int kapasitasMaks;
  final GerbongModel gerbong;
  final VoidCallback onTap;

  const CargoCard({
    super.key,
    required this.kodeGerbong,
    required this.jenisGerbong,
    required this.kapasitasTerisi,
    required this.kapasitasMaks,
    required this.gerbong,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double persentase = kapasitasMaks > 0 ? kapasitasTerisi / kapasitasMaks : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: CargoTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CargoTheme.primary.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GerbongDetailPage(gerbong: gerbong),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.directions_railway_filled_rounded, color: CargoTheme.accent, size: 28),
                        const SizedBox(width: 12),
                        Text(kodeGerbong, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CargoTheme.primary)),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400)
                  ],
                ),
                const SizedBox(height: 6),
                Text(jenisGerbong, style: CargoTheme.subtitleStyle),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(height: 1, color: Color(0xFFE2E8F0)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Kapasitas Efektif Muatan", style: TextStyle(fontSize: 13, color: Colors.black54)),
                    Text("$kapasitasTerisi / $kapasitasMaks Ton", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CargoTheme.primary)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: persentase,
                    backgroundColor: Colors.grey.shade100,
                    color: persentase > 0.85 ? Colors.redAccent : CargoTheme.primary,
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
