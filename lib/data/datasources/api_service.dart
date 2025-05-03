import 'package:ai_radiologist_flutter/business_logic/cubit/auth_cubit.dart';
import 'package:ai_radiologist_flutter/constants/settings.dart';
import 'package:ai_radiologist_flutter/data/datasources/auth_storage.dart';
import 'package:ai_radiologist_flutter/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApiService {
  // 1) Singleton boilerplate
  static final ApiService _instance = ApiService._internal();
  late final Dio dio;

  factory ApiService() => _instance;

  // 2) Private constructor
  ApiService._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 240),
        receiveTimeout: const Duration(seconds: 360),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    Future<String?> _refreshToken() async {
      final refreshToken = await AuthStorage.getRefreshToken();
      if (refreshToken == null) return null;
      try {
        final response = await dio.post('/auth/token/refresh/', data: {'refresh': refreshToken});
        if (response.statusCode == 200) {
          final newAccessToken = response.data['access'];
          await AuthStorage.saveTokens(newAccessToken, refreshToken);
          return newAccessToken;
        }
        if (response.statusCode == 401) {
          return null;
        }
      } catch (e) {
        return null;
      }
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await AuthStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            // إذا لم يكن التوكن موجودًا، يمكن إلقاء Exception (أو معالجة أخرى)
            // handler.reject(onError);
          }
          handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            final newToken = await _refreshToken();
            if (newToken != null) {
              error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final clonedRequest = await dio.fetch(error.requestOptions);
              return handler.resolve(clonedRequest);
            } else {
              await AuthStorage.clearTokens();

              final authCubit = BlocProvider.of<AuthCubit>(navigatorKey.currentContext!);
              authCubit.emit(AuthUnauthenticated());

              return handler.next(error);
            }
          } else {
            handler.next(error);
          }
        },
      ),
    );
  }
}