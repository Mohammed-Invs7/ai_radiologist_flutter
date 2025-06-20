// lib/data/models/report.dart
class Report {
  final int id;
  final String title;
  final String radiologyModality;
  final String bodyAnatomicalRegion;
  final DateTime reportDate;
  final String imagePath;

  Report({
    required this.id,
    required this.title,
    required this.radiologyModality,
    required this.bodyAnatomicalRegion,
    required this.reportDate,
    required this.imagePath,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      title: json['title'],
      radiologyModality: json['radiology_modality'],
      bodyAnatomicalRegion: json['body_anatomical_region'],
      reportDate: DateTime.parse(json['report_date']),
      imagePath: json['image_path'],
    );
  }
}
