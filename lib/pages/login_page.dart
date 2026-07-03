import 'package:flutter/material.dart';
import '../shared/theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [CargoTheme.primary, CargoTheme.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo/Ikon Kereta Kargo Kreatif
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CargoTheme.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.train_rounded,
                  size: 48,
                  color: CargoTheme.accent,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Cargo Rail System",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Text(
                "Sistem Manajemen Data Inventaris & Logistik",
                style: TextStyle(fontSize: 14, color: Colors.white60),
              ),
              const SizedBox(height: 32),
              
              // Form Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: CargoTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email Petugas',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Tombol Login Menarik
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CargoTheme.accent,
                          foregroundColor: CargoTheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // Hubungkan ke Event BLoC Login di sini nanti
                        },
                        child: const Text(
                          "Masuk Ke Sistem",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}