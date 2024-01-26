import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/report_model.dart';

class ReportsController {
  FirebaseFirestore firestore;

  ReportsController({required this.firestore});

  Future<List<ReportModel>> findAll() async {
    final querySnapshot = await firestore.collection("reports").get();
    final reports = querySnapshot.docs
        .map((doc) => ReportModel.fromMap(doc.data())..id = doc.id)
        .toList();
    reports.sort((a, b) => b.createdAt.toDate().compareTo(
          a.createdAt.toDate(),
        ));
    return reports;
  }

  Future<ReportModel?> findById(String id) async {
    final doc = await firestore.collection("reports").doc(id).get();
    if (doc.exists) {
      return ReportModel.fromMap(doc.data()!)..id = doc.id;
    }
    return null;
  }

  Future<void> save(ReportModel reportModel) async {
    await firestore.collection("reports").add(reportModel.toMap());
  }

  Future<void> update(ReportModel reportModel) async {
    await firestore
        .collection("reports")
        .doc(reportModel.id)
        .update(reportModel.toMap());
  }

  Future<void> delete(ReportModel reportModel) async {
    await firestore.collection("reports").doc(reportModel.id).delete();
  }
}
