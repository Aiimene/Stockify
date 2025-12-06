import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit(this._repository) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    
    final result = await _repository.getUserProfile();
    
    if (result['success'] == true) {
      emit(ProfileLoaded(user: result['user'] as User));
    } else {
      emit(ProfileError(message: result['message'] as String));
    }
  }

  Future<void> updateProfile({
    String? email,
    String? fullName,
    String? password,
  }) async {
    emit(ProfileLoading());
    
    final result = await _repository.updateProfile(
      email: email,
      fullName: fullName,
      password: password,
    );
    
    if (result['success'] == true) {
      emit(ProfileUpdated(user: result['user'] as User, message: result['message'] as String));
      // Reload profile to get latest data
      await loadProfile();
    } else {
      emit(ProfileError(message: result['message'] as String));
    }
  }
}

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;

  ProfileLoaded({required this.user});
}

class ProfileUpdated extends ProfileState {
  final User user;
  final String message;

  ProfileUpdated({required this.user, required this.message});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}

