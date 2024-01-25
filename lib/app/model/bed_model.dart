import 'package:cloud_firestore/cloud_firestore.dart';

import 'patient_model.dart';

class BedModel {
  String? id;
  String name;
  Timestamp createdAt;
  PatientModel? patient;

  BedModel({
    this.id,
    required this.name,
    required this.createdAt,
    this.patient,
  });

  BedModel.fromMap(Map<String, dynamic> map)
      : name = map["name"],
        patient = map["patient"] != null
            ? PatientModel.fromMap(map["patient"])
            : null,
        createdAt = map["createdAt"];

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "patient": patient,
      "createdAt": createdAt,
    };
  }
}
