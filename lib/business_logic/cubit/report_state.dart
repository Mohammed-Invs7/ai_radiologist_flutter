part of 'report_cubit.dart';

@immutable
sealed class ReportState {}

final class ReportInitial extends ReportState {}

final class ReportUploading extends ReportState {}

final class ReportSuccess extends ReportState {
  final String report;
  ReportSuccess(this.report);
}

class ReportError extends ReportState {
  final String message;
  ReportError(this.message);
}
