part of 'report_cubit.dart';

@immutable
sealed class ReportState {}

final class ReportInitial extends ReportState {}

final class ReportUploading extends ReportState {}

final class ReportSuccess extends ReportState {
  final String report;
  ReportSuccess(this.report);
}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final List<Report> reports;
  ReportLoaded(this.reports);
}

class ReportError extends ReportState {
  final String message;
  ReportError(this.message);
}

class ReportDetailInitial extends ReportState {}

class ReportDetailLoading extends ReportState {}

class ReportDetailLoaded extends ReportState {
  final ReportDetail reportDetail;
  ReportDetailLoaded(this.reportDetail);
}

class ReportDeleted extends ReportState {}

class ReportDetailError extends ReportState {
  final String message;
  ReportDetailError(this.message);
}

class ReportPdfInitial extends ReportState {}
class ReportPdfDownloading extends ReportState {}
class ReportPdfDownloaded extends ReportState {
  final String filePath;
  ReportPdfDownloaded(this.filePath);
}
class ReportPdfDownloadError extends ReportState {
  final String message;
  ReportPdfDownloadError(this.message);
}

