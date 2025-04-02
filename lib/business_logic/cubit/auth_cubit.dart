import 'package:ai_radiologist_flutter/business_logic/repositories/auth_repository.dart';
import 'package:ai_radiologist_flutter/data/datasources/auth_storage.dart';
import 'package:ai_radiologist_flutter/data/models/models.dart';
import 'package:ai_radiologist_flutter/main.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.login(email, password);
      // If we reach here, it's success
      emit(AuthSuccess(user));
    } catch (error) {
      // Any exception thrown in repository is caught here
      emit(AuthError(error.toString()));
    }
  }

  Future<void> logout() async {
    await AuthStorage.clearTokens();
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
    // emit(AuthUnauthenticated());
  }

  void signup(UserRegister userRegister) async {
    emit(AuthLoading());
    try {
      final message = await authRepository.signup(userRegister);
      emit(AuthRegistrationSuccess(message));
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }



}