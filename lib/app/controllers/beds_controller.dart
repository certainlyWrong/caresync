import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/bed_model.dart';

class BedsController {
  FirebaseFirestore firestore;

  BedsController({required this.firestore});

  Future<List<BedModel>> findAll() async {
    final querySnapshot = await firestore.collection("beds").get();
    final beds = querySnapshot.docs
        .map((doc) => BedModel.fromMap(doc.data())..id = doc.id)
        .toList();
    beds.sort((a, b) => a.name.compareTo(b.name));
    // ordenar relatorios por data
    for (var bed in beds) {
      bed.reports.sort(
        (a, b) => b.createdAt.toDate().compareTo(
              a.createdAt.toDate(),
            ),
      );
    }
    return beds;
  }

  Future<BedModel?> findById(String id) async {
    final doc = await firestore.collection("beds").doc(id).get();
    if (doc.exists) {
      return BedModel.fromMap(doc.data()!)..id = doc.id;
    }
    return null;
  }

  Future<void> save(BedModel bedModel) async {
    await firestore.collection("beds").add(bedModel.toMap());
  }

  Future<void> update(BedModel bedModel) async {
    await firestore
        .collection("beds")
        .doc(bedModel.id)
        .update(bedModel.toMap());
  }

  Future<void> delete(BedModel bedModel) async {
    await firestore.collection("beds").doc(bedModel.id).delete();
  }

  Future<void> assignPatient(BedModel bedModel) async {
    await firestore
        .collection("beds")
        .doc(bedModel.id)
        .update({"patient": bedModel.patient?.toMap()});
  }

  Future<void> removePatient(BedModel bedModel) async {
    await firestore.collection("beds").doc(bedModel.id).update({
      "patient": null,
      "reports": null,
    });
  }
}
