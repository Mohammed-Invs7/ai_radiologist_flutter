import 'package:ai_radiologist_flutter/data/datasources/api_service.dart';
// import 'package:ai_radiologist_flutter/data/datasources/auth_storage.dart';
import 'package:ai_radiologist_flutter/data/models/models.dart';
import 'package:dio/dio.dart';
import 'dart:io';


class ReportRepository {

  ReportRepository();

  Future<String> createReport(File imageFile) async {
    try {
      // استخراج اسم الملف من المسار
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "image_path": await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      // إرسال الطلب إلى الـ API (تأكد من ضبط الرابط الصحيح)
      Response response = await ApiService().dio.post(
        "/api/v1/user/reports/create/",
        data: formData,
        options: Options(
          headers: {"Content-Type": "multipart/form-data"},
        ),
      );

      if (response.statusCode == 200) {
        // نفترض أن السيرفر يعيد التقرير في مفتاح "report"
        return response.data["report_details"];
      } else {
        throw Exception("Upload failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error uploading image: $e");
    }
  }
}