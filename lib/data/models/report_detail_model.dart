class ReportDetail {
  final int id;
  final String title;
  final String radiologyModality;
  final String bodyAnatomicalRegion;
  final DateTime reportDate;
  final String imagePath;
  final String reportDetails;

  ReportDetail({
    required this.id,
    required this.title,
    required this.radiologyModality,
    required this.bodyAnatomicalRegion,
    required this.reportDate,
    required this.imagePath,
    required this.reportDetails,
  });

  factory ReportDetail.fromJson(Map<String, dynamic> json) {
    return ReportDetail(
      id: json['id'],
      title: json['title'],
      radiologyModality: json['radiology_modality'],
      bodyAnatomicalRegion: json['body_anatomical_region'],
      reportDate: DateTime.parse(json['report_date']),
      imagePath: json['image_path'],
      reportDetails: json['report_details'],
    );
  }
}
