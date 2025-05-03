import './region_model.dart';

class ReportOption {
  final int modalityId;
  final String modalityName;
  final List<Region> regions;

  ReportOption({required this.modalityId, required this.modalityName, required this.regions});

  factory ReportOption.fromJson(Map<String, dynamic> json) => ReportOption(
    modalityId: json['modality']['id'],
    modalityName: json['modality']['name'],
    regions: (json['regions'] as List)
        .map((r) => Region(id: r['id'], name: r['name']))
        .toList(),
  );
}