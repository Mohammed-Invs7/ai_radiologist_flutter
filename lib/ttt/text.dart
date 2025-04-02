import 'package:dio/dio.dart';
import '../data/models/models.dart';

void login(String email, String password) async {
  Dio dio = Dio();

  try {
    Response response = await dio.post(
      'http://localhost:8000/api/v1/auth/login/', // رابط API الخاص بتسجيل الدخول
      data: {
        'email': email,
        'password': password,
      },
    );

    print('🟢 Login Successful!');

    // تحويل الاستجابة إلى كائن Auth باستخدام Auth.fromJson
    Auth auth = Auth.fromJson(response.data);

    // طباعة بيانات التوكنات
    print('Access Token: ${auth.accessToken}');
    print('Refresh Token: ${auth.refreshToken}');

    // التحقق من وجود بيانات المستخدم وطباعة التفاصيل
    if (auth.user != null) {
      print('----- User Details -----');
      print('User ID      : ${auth.user!.pk}');
      print('Email        : ${auth.user!.email}');
      print('First Name   : ${auth.user!.firstName}');
      print('Last Name    : ${auth.user!.lastName}');
      print('Gender       : ${auth.user!.gender}');
      print('Age          : ${auth.user!.age}');
      print('Date of Birth: ${auth.user!.dateOfBirth}');
      print('Join Date    : ${auth.user!.joinDate}');
      print('Profile Image: ${auth.user!.profileImage}');
    }

    // يمكنك استدعاء دالة fetchUserData مع access token إذا أردت استخدامها:
    // fetchUserData(auth.accessToken!);

  } catch (e) {
    print('❌ Login Failed: $e');
  }
}


Future<void> fetchUserData(String? token) async {
  Dio dio = Dio();
  // String? token = await storage.read(key: 'access_token');

  if (token == null) {
    print('❌ لا يوجد توكن، يجب تسجيل الدخول');
    return;
  }

  try {
    Response response = await dio.get(
      'http://localhost:8000/api/v1/auth/user/',
      options: Options(
        headers: {'Authorization': 'Bearer $token'}, // إضافة التوكن في الهيدر
      ),
    );

    print('🟢 بيانات المستخدم: ${response.data}');

  } catch (e) {
    print('❌ فشل جلب البيانات: $e');
  }
}

void main() {
  login('test@gmail.com', '1234'); // تجربة تسجيل الدخول
  // fetchUserData('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzQyMDgxNjY3LCJpYXQiOjE3NDIwNzgwNjcsImp0aSI6IjI4MzZkY2ZiYTJiNjQ3NzZhMzFhM2YzYjM1ZjI2NzRhIiwidXNlcl9pZCI6MX0t8LWK1HbNiifFB_5XKpT_YQ8SyIfld_PlCet4MoymyE');
}