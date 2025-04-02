import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:ai_radiologist_flutter/business_logic/repositories/report_repository.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepository reportRepository;

  ReportCubit(this.reportRepository) : super(ReportInitial());

  Future<void> createReport(File imageFile) async {
    emit(ReportUploading());
    try {
      final report = await reportRepository.createReport(imageFile);
      emit(ReportSuccess(report));
    } catch (error) {
      emit(ReportError(error.toString()));
    }
  }
}