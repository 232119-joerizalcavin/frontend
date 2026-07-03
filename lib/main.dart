import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/auth/auth_state.dart';
import 'blocs/gerbong/gerbong_bloc.dart';
import 'pages/gerbong/gerbong_list_page.dart';
import 'pages/login/login_page.dart';
import 'shared/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(const CheckAuthStatus()),
        ),
        BlocProvider<GerbongBloc>(
          create: (context) => GerbongBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Komando Logistik Kereta Api',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: CargoTheme.primary,
          scaffoldBackgroundColor: CargoTheme.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: CargoTheme.primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: CargoTheme.primary,
            primary: CargoTheme.primary,
            secondary: CargoTheme.accent,
          ),
          useMaterial3: true,
        ),
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) => const GerbongListPage(),
        },
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            print('🔐 Main BlocBuilder - Auth state: ${state.runtimeType}');
            if (state is AuthAuthenticated) {
              print('✅ User authenticated, showing GerbongListPage');
              return const GerbongListPage();
            } else {
              print('❌ User not authenticated, showing LoginPage');
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
