import 'package:cloud_firestore/cloud_firestore.dart';

import 'report_model.dart';

class PatientModel {
  String name;
  Timestamp createdAt;
  List<ReportModel> reports = [];

  PatientModel({
    required this.name,
    required this.createdAt,
  });

  PatientModel.fromMap(Map<String, dynamic> map)
      : name = map["name"],
        createdAt = map["createdAt"];

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "createdAt": createdAt,
    };
  }
}
