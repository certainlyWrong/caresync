import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  String? id;
  Timestamp createdAt;
  // Interrupção diária da sedação
  bool interruptionDailySedation;

  // Pressao do cuff 18-22mmHg ou 25cmH2O
  bool cuffPressure;

  // Sistema de umidificação adequado
  bool adequateHumidificationSystem;

  // Desmame de VM/ teste de respiração espontânea
  bool weaningMV;

  // Cabeceira elevada 30-45º
  bool elevatedHeadboard;

  // Higiene oral com clorexidina
  bool oralHygiene;

  // Sujidade do circuito
  bool circuitDirt;

  ReportModel({
    required this.createdAt,
    required this.interruptionDailySedation,
    required this.cuffPressure,
    required this.adequateHumidificationSystem,
    required this.weaningMV,
    required this.elevatedHeadboard,
    required this.oralHygiene,
    required this.circuitDirt,
  });

  ReportModel.fromMap(Map<String, dynamic> map)
      : createdAt = map['createdAt'],
        interruptionDailySedation = map['interruptionDailySedation'],
        cuffPressure = map['cuffPressure'],
        adequateHumidificationSystem = map['adequateHumidificationSystem'],
        weaningMV = map['weaningMV'],
        elevatedHeadboard = map['elevatedHeadboard'],
        oralHygiene = map['oralHygiene'],
        circuitDirt = map['circuitDirt'];

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'interruptionDailySedation': interruptionDailySedation,
      'cuffPressure': cuffPressure,
      'adequateHumidificationSystem': adequateHumidificationSystem,
      'weaningMV': weaningMV,
      'elevatedHeadboard': elevatedHeadboard,
      'oralHygiene': oralHygiene,
      'circuitDirt': circuitDirt,
    };
  }
}
