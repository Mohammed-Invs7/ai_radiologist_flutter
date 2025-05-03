import 'dart:io';

import 'package:ai_radiologist_flutter/data/models/models.dart';
import 'package:dio/dio.dart';
import 'package:ai_radiologist_flutter/data/datasources/api_service.dart';

class UserRepository {
  final Dio dio = ApiService().dio;


  Future<User> fetchUser() async {
    try {
      Response response = await dio.get('/auth/user/');
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }


  Future<User> updateUserName(String firstName, String lastName) async {
    try {
      Response response = await dio.patch(
        '/auth/user/',
        data: {
          'first_name': firstName,
          'last_name': lastName,
        },
      );
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to update user name. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating user name: $e');
    }
  }

  // edit gender
  Future<User> updateUserGender(String gender) async {
    try {
      Response response = await dio.patch(
        '/auth/user/',
        data: {
          'gender': gender,
        },
      );
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to update user gender. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating user gender: $e');
    }
  }

  // edit profile image
  Future<User> updateUserProfileImage(File imageFile) async {
    try {
      final fileName = imageFile.path
          .split('/')
          .last;
      final formData = FormData.fromMap({
        'profile_image': await MultipartFile.fromFile(
            imageFile.path, filename: fileName),
      });

      final response = await dio.patch(
          '/auth/user/',
          data: formData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'})
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to update profile image. Status code: ${response
            .statusCode}');
      }
    }
    catch (e) {
      throw Exception('Error updating profile image: $e');
    }
  }
}