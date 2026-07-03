import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../shared/theme.dart';
import '../gerbong/gerbong_list_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CargoTheme.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigasi ke home page
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => GerbongListPage()),
            );
          } else if (state is AuthError) {
            // Tampilkan error dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header dengan gradient
                  Container(
                    height: 250,
                    decoration: const BoxDecoration(
                      color: CargoTheme.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.directions_railway_filled_rounded,
                          size: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'KERETA KARGO',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sistem Manajemen Logistik',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Form Container
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        const Text(
                          'Masuk ke Akun',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: CargoTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Email Field
                        TextField(
                          controller: _emailController,
                          enabled: state is! AuthLoading,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            prefixIcon: const Icon(
                              Icons.email_rounded,
                              color: CargoTheme.primary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE2E8F0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE2E8F0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: CargoTheme.primary,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 16),

                        // Password Field
                        TextField(
                          controller: _passwordController,
                          enabled: state is! AuthLoading,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock_rounded,
                              color: CargoTheme.primary,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: CargoTheme.primary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE2E8F0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE2E8F0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: CargoTheme.primary,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Login Button
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
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                                    if (_emailController.text.isEmpty ||
                                        _passwordController.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Email dan password harus diisi'),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                      return;
                                    }

                                    context.read<AuthBloc>().add(
                                          LoginRequested(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                          ),
                                        );
                                  },
                            child: state is AuthLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'MASUK',
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

                        // Demo Info
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: CargoTheme.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: CargoTheme.secondary.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '📋 Demo Credentials:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CargoTheme.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Email: admin@keretakargo.com',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Password: password123',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
