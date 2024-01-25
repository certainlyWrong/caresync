import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/not_found_component.dart';
import '../controllers/beds_controller.dart';
import '../model/bed_model.dart';
import '../model/patient_model.dart';

class ReportsPage extends StatefulWidget {
  final BedModel bed;
  const ReportsPage({
    super.key,
    required this.bed,
  });

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  late BedsController bedsController;
  late PatientModel patient;

  @override
  void initState() {
    bedsController = BedsController(
      firestore: FirebaseFirestore.instance,
    );
    patient = widget.bed.patient!;
    super.initState();
  }

  showAddReportDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adicionar relatório"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CheckboxListTile(
                    title: const Text("Interrupção diária da sedação"),
                    value: patient.reports.last.interruptionDailySedation,
                    onChanged: (value) {
                      patient.reports.last.interruptionDailySedation = value!;
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Pressão do cuff 18-22mmHg ou 25cmH2O"),
                    value: patient.reports.last.cuffPressure,
                    onChanged: (value) {
                      patient.reports.last.cuffPressure = value!;
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Sistema de umidificação adequado"),
                    value: patient.reports.last.adequateHumidificationSystem,
                    onChanged: (value) {
                      patient.reports.last.adequateHumidificationSystem =
                          value!;
                    },
                  ),
                  CheckboxListTile(
                    title: const Text(
                        "Desmame de VM/ teste de respiração espontânea"),
                    value: patient.reports.last.weaningMV,
                    onChanged: (value) {
                      patient.reports.last.weaningMV = value!;
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Cabeceira elevada 30-45º"),
                    value: patient.reports.last.elevatedHeadboard,
                    onChanged: (value) {
                      patient.reports.last.elevatedHeadboard = value!;
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Higiene oral com clorexidina"),
                    value: patient.reports.last.oralHygiene,
                    onChanged: (value) {
                      patient.reports.last.oralHygiene = value!;
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Sujidade do circuito"),
                    value: patient.reports.last.circuitDirt,
                    onChanged: (value) {
                      patient.reports.last.circuitDirt = value!;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await bedsController.update(widget.bed);
                Navigator.of(context).pop();
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${patient.name} - ${DateFormat("dd/MM/yyyy").format(
            patient.createdAt.toDate(),
          )}",
          overflow: TextOverflow.ellipsis,
        ),
      ),
      floatingActionButton: SizedBox(
        width: 200,
        child: FloatingActionButton(
          onPressed: showAddReportDialog,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              SizedBox(width: 5),
              Text(
                "Adicionar",
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Builder(builder: (context) {
        if (patient.reports.isEmpty) {
          return const Center(
            child: NotFoundComponent(
              title: "Sem relatórios",
            ),
          );
        }

        return DataTable2(
          columns: const [
            DataColumn(label: Text('Data')),
            DataColumn(label: Text('Interrupção diária da sedação')),
            DataColumn(label: Text('Pressão do cuff 18-22mmHg ou 25cmH2O')),
            DataColumn(label: Text('Sistema de umidificação adequado')),
            DataColumn(
                label: Text('Desmame de VM/ teste de respiração espontânea')),
            DataColumn(label: Text('Cabeceira elevada 30-45º')),
            DataColumn(label: Text('Higiene oral com clorexidina')),
            DataColumn(label: Text('Sujidade do circuito')),
          ],
          rows: patient.reports
              .map(
                (report) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                        DateFormat("dd/MM/yyyy").format(
                          report.createdAt.toDate(),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        report.interruptionDailySedation ? "Sim" : "Não",
                      ),
                    ),
                    DataCell(
                      Text(
                        report.cuffPressure ? "Sim" : "Não",
                      ),
                    ),
                    DataCell(
                      Text(
                        report.adequateHumidificationSystem ? "Sim" : "Não",
                      ),
                    ),
                    DataCell(
                      Text(
                        report.weaningMV ? "Sim" : "Não",
                      ),
                    ),
                    DataCell(
                      Text(
                        report.elevatedHeadboard ? "Sim" : "Não",
                      ),
                    ),
                    DataCell(
                      Text(
                        report.oralHygiene ? "Sim" : "Não",
                      ),
                    ),
                    DataCell(
                      Text(
                        report.circuitDirt ? "Sim" : "Não",
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        );
      }),
    );
  }
}
