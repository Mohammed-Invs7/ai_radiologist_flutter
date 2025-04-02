import 'package:ai_radiologist_flutter/data/datasources/api_service.dart';
import 'package:ai_radiologist_flutter/data/datasources/auth_storage.dart';
import 'package:ai_radiologist_flutter/data/models/models.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  AuthRepository();

  Future<User> login(String email, String password) async {
    try {
      Response response = await ApiService().dio.post(
        '/auth/login/',
        data: {
          'email': email,
          'password': password,
        },
      );

      // Check status code or server error
      if (response.statusCode == 200) {
        await AuthStorage.saveTokens(response.data['access'], response.data['refresh']);
        return User.fromJson(response.data['user']);
      }
      else if (response.statusCode == 400) {
        final errorMessage = response.data.toString();
        throw Exception(errorMessage);
      }
      else {
        throw Exception('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Re-throw or convert to a custom exception
      throw Exception('Failed to login: $e');
    }
  }

  Future<String> signup(UserRegister userRegister) async {
    try {
      Response response = await ApiService().dio.post(
        '/auth/registration/',
        data: userRegister.toJson()
      );

      if (response.statusCode == 201) {
        return response.data['detail'];
      } else if (response.statusCode == 400) {
        final errorMessage = response.data.toString();
        throw Exception('Invalid registration details: $errorMessage');
      } else {
        throw Exception('Registration failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }



}