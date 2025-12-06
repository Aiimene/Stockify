import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user.dart';
import '../../data/repositories/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    
    final result = await _repository.login(email, password);
    
    if (result['success'] == true) {
      emit(AuthSuccess(
        user: result['user'] as User,
        token: result['token'] as String,
      ));
    } else {
      emit(AuthError(message: result['message'] as String));
    }
  }

  Future<void> register(String email, String password, String fullName) async {
    emit(AuthLoading());
    
    // First, register the user
    final registerResult = await _repository.register(email, password, fullName);
    
    if (registerResult['success'] == true) {
      // After successful registration, automatically log in
      final loginResult = await _repository.login(email, password);
      
      if (loginResult['success'] == true) {
        // Login successful - emit AuthSuccess to navigate to home
        emit(AuthSuccess(
          user: loginResult['user'] as User,
          token: loginResult['token'] as String,
        ));
      } else {
        // Registration succeeded but login failed - show error but keep user registered
        emit(AuthError(
          message: 'Account created successfully, but automatic login failed. Please login manually.',
        ));
      }
    } else {
      emit(AuthError(message: registerResult['message'] as String));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(AuthInitial());
  }
}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  final String token;

  AuthSuccess({required this.user, required this.token});
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}

