class Report {
  int? id;
  String? title;
  String? radiologyModality;
  String? bodyAnatomicalRegion;
  String? reportDate;
  String? imagePath;

  Report(
      {this.id,
        this.title,
        this.radiologyModality,
        this.bodyAnatomicalRegion,
        this.reportDate,
        this.imagePath});

  Report.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    radiologyModality = json['radiology_modality'];
    bodyAnatomicalRegion = json['body_anatomical_region'];
    reportDate = json['report_date'];
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['radiology_modality'] = this.radiologyModality;
    data['body_anatomical_region'] = this.bodyAnatomicalRegion;
    data['report_date'] = this.reportDate;
    data['image_path'] = this.imagePath;
    return data;
  }
}
