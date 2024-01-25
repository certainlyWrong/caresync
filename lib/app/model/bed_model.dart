import 'package:cloud_firestore/cloud_firestore.dart';

import 'patient_model.dart';
import 'report_model.dart';

class BedModel {
  String? id;
  String name;
  Timestamp createdAt;
  PatientModel? patient;
  List<ReportModel> reports;

  BedModel({
    this.id,
    required this.name,
    required this.createdAt,
    required this.reports,
    this.patient,
  });

  BedModel.fromMap(Map<String, dynamic> map)
      : name = map["name"],
        reports = map["reports"] != null
            ? List<ReportModel>.from(
                map["reports"].map((x) => ReportModel.fromMap(x)))
            : [],
        patient = map["patient"] != null
            ? PatientModel.fromMap(map["patient"])
            : null,
        createdAt = map["createdAt"];

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "patient": patient?.toMap(),
      "reports": reports.map((x) => x.toMap()).toList(),
      "createdAt": createdAt,
    };
  }
}
