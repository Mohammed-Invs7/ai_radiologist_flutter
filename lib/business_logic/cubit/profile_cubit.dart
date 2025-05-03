import 'dart:io';

import 'package:ai_radiologist_flutter/business_logic/repositories/repositories.dart';
import 'package:ai_radiologist_flutter/data/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository userRepository;

  ProfileCubit(this.userRepository) : super(ProfileInitial());

  Future<void> fetchUserProfile() async {
    emit(ProfileLoading());
    try {
      final user = await userRepository.fetchUser();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateUserName(String firstName, String lastName) async {
    emit(ProfileLoading());
    try {
      final user = await userRepository.updateUserName(firstName, lastName);
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateUserGender(String gender) async {
    emit(ProfileLoading());
    try {
      final user = await userRepository.updateUserGender(gender);
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateUserProfileImage(File imageFile) async {
    emit(ProfileLoading());
    try {
      final user = await userRepository.updateUserProfileImage(imageFile);
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}