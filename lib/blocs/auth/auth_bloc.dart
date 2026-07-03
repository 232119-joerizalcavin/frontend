import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService();

  AuthBloc() : super(const AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(const AuthLoading());
      try {
        print('🔐 Attempting login with email: ${event.email}');
        
        final response = await _authService.login(event.email, event.password);
        
        print('✅ Login response: $response');
        
        final userData = response['data']['user'];
        final token = response['data']['access_token'];
        
        print('🎫 Token received: ${token.substring(0, 20)}...');
        
        final user = UserModel(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
        );

        emit(AuthAuthenticated(user: user, token: token));
        print('✨ AuthAuthenticated emitted');
      } catch (e) {
        print('❌ Login error: $e');
        emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(const AuthLoading());
      try {
        await _authService.register(event.name, event.email, event.password);
        
        // After registration, auto-login
        final response = await _authService.login(event.email, event.password);
        
        final userData = response['data']['user'];
        final token = response['data']['access_token'];
        
        final user = UserModel(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
        );

        emit(AuthAuthenticated(user: user, token: token));
      } catch (e) {
        emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<LogoutRequested>((event, emit) async {
      try {
        print('🔐 Attempting logout...');
        await _authService.logout();
        print('✅ Logout successful');
        emit(const AuthUnauthenticated());
      } catch (e) {
        print('⚠️ Logout error (but clearing local data): $e');
        // Tetap emit AuthUnauthenticated meskipun API gagal
        // karena token sudah dihapus dari SharedPreferences
        emit(const AuthUnauthenticated());
      }
    });

    on<CheckAuthStatus>((event, emit) async {
      try {
        final isLoggedIn = await _authService.isLoggedIn();
        print('🔍 Checking auth status: $isLoggedIn');
        
        if (isLoggedIn) {
          final email = await _authService.getUserEmail();
          final token = await _authService.getToken();
          
          print('✅ User is logged in. Token: ${token?.substring(0, 20)}...');
          
          final user = UserModel(
            id: 0,
            name: 'User',
            email: email ?? '',
          );
          emit(AuthAuthenticated(user: user, token: token ?? ''));
        } else {
          print('❌ User is not logged in');
          emit(const AuthUnauthenticated());
        }
      } catch (e) {
        print('❌ Error checking auth: $e');
        emit(const AuthUnauthenticated());
      }
    });
  }
}

