import 'package:ai_radiologist_flutter/data/datasources/api_service.dart';
import 'package:ai_radiologist_flutter/data/models/models.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportRepository {

  ReportRepository();

  Future<String> createReport({required File imageFile, required int modalityId, required int regionId,}) async {
    try {

      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        'radio_modality': modalityId,
        'body_ana': regionId,
        "image_path": await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      Response response = await ApiService().dio.post(
        "/user/reports/create/",
        data: formData,
        options: Options(
          headers: {"Content-Type": "multipart/form-data"},
        ),
      );

      if (response.statusCode == 201) {
        return response.data["report_details"];
      } else {
        throw Exception("Upload failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error uploading image: $e");
    }
  }


  Future<List<Report>> fetchReports() async {
    try {
      Response response = await ApiService().dio.get('/user/reports/');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Report.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch reports with status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching reports: $e");
    }
  }

  // جلب تفاصيل التقرير
  Future<ReportDetail> fetchReportDetail(int id) async {
    try {
      Response response = await ApiService().dio.get('/user/reports/$id/');
      if (response.statusCode == 200) {
        return ReportDetail.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch report details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching report details: $e');
    }
  }

  // تعديل عنوان التقرير (PATCH)
  Future<ReportDetail> updateReportTitle(int id, String newTitle) async {
    try {
      Response response = await ApiService().dio.patch(
        '/user/reports/$id/',
        data: {'title': newTitle},
      );
      if (response.statusCode == 200) {
        return ReportDetail.fromJson(response.data);
      } else {
        throw Exception('Failed to update report title. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating report title: $e');
    }
  }

  // حذف التقرير
  Future<void> deleteReport(int id) async {
    try {
      Response response = await ApiService().dio.delete('/user/reports/$id/');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete report. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting report: $e');
    }
  }

  Future<String> downloadReportPdf(int id) async {
    try {
      Response response = await ApiService().dio.get(
        '/user/reports/$id/pdf/',
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        if (Platform.isAndroid) {
          print("heloo");
          var status = await Permission.storage.request();
          if (!status.isGranted) {
            print("heloo");
            throw Exception('Storage permission is required');
          }
        }
        Directory? downloadsDirectory;
        if (Platform.isAndroid) {
          downloadsDirectory = await getExternalStorageDirectory();
        } else if (Platform.isIOS) {
          downloadsDirectory = await getApplicationDocumentsDirectory();
        } else {
          throw Exception('Unsupported platform');
        }
        final Directory reportsDirectory = Directory('${downloadsDirectory!.path}/AI_Radiologist-Reports');
        if (!await reportsDirectory.exists()) {
          await reportsDirectory.create(recursive: true);
        }
        String filePath = '${reportsDirectory.path}/report_$id.pdf';
        File file = File(filePath);
        await file.writeAsBytes(response.data);
        // فتح الملف (يمكن فتحه مباشرة هنا إذا رغبت، لكن الأفضل ترك ذلك للواجهة)
        // await OpenFile.open(filePath);

        return filePath;
      } else {
        throw Exception('Failed to download PDF. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error downloading PDF: $e');
    }
  }

  Future<List<ReportOption>> fetchReportOptions() async {
    final resp = await ApiService().dio.get('/user/reports/options/');
    if (resp.statusCode == 200) {
      return (resp.data as List)
          .map((e) => ReportOption.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load options');
    }
  }

}