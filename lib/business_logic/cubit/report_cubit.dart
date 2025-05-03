import 'package:ai_radiologist_flutter/data/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:ai_radiologist_flutter/business_logic/repositories/report_repository.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepository reportRepository;
  List<ReportOption> _options = [];

  ReportCubit(this.reportRepository) : super(ReportInitial());

  Future<void> createReport(File imageFile, {required int modalityId, required int regionId,}) async {
    emit(ReportUploading());
    try {
      final report = await reportRepository.createReport(
        imageFile: imageFile,
        modalityId: modalityId,
        regionId: regionId,
      );
      emit(ReportSuccess(report));
    } catch (error) {
      emit(ReportError(error.toString()));
    }
  }

  Future<void> fetchReports() async {
    emit(ReportLoading());
    try {
      final reports = await reportRepository.fetchReports();
      emit(ReportLoaded(reports));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }


  Future<void> fetchReportDetail(int id) async {
    emit(ReportDetailLoading());
    try {
      final reportDetail = await reportRepository.fetchReportDetail(id);
      emit(ReportDetailLoaded(reportDetail));
    } catch (e) {
      emit(ReportDetailError(e.toString()));
    }
  }

  Future<void> updateReportTitle(int id, String newTitle) async {
    emit(ReportDetailLoading());
    try {
      final updatedReport = await reportRepository.updateReportTitle(id, newTitle);
      emit(ReportDetailLoaded(updatedReport));
    } catch (e) {
      emit(ReportDetailError(e.toString()));
    }
  }

  Future<void> deleteReport(int id) async {
    emit(ReportDetailLoading());
    try {
      await reportRepository.deleteReport(id);
      emit(ReportDeleted());
    } catch (e) {
      emit(ReportDetailError(e.toString()));
    }
  }


  Future<String?> downloadPdf(int id) async {
    emit(ReportPdfDownloading());
    try {
      final filePath = await reportRepository.downloadReportPdf(id);
      emit(ReportPdfDownloaded(filePath));
    } catch (e) {
      emit(ReportPdfDownloadError(e.toString()));
    }
  }

  Future<void> fetchReportOptions() async {
    emit(ReportOptionsLoading());
    try {
      _options = await reportRepository.fetchReportOptions();
      emit(ReportOptionsLoaded(_options));
    } catch (e) {
      emit(ReportOptionsError(e.toString()));
    }
  }

  List<ReportOption> get options => _options;

}