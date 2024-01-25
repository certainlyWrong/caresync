import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/not_found_component.dart';
import '../controllers/beds_controller.dart';
import '../model/bed_model.dart';
import '../model/report_model.dart';

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
  late BedModel bed;

  @override
  void initState() {
    bedsController = BedsController(
      firestore: FirebaseFirestore.instance,
    );
    bed = widget.bed;
    super.initState();
  }

  showAddReportDialog() {
    showDialog(
      context: context,
      builder: (context) {
        late ReportModel lastReport;

        if (bed.reports.isEmpty) {
          lastReport = ReportModel(
            createdAt: Timestamp.now(),
            interruptionDailySedation: false,
            cuffPressure: false,
            adequateHumidificationSystem: false,
            weaningMV: false,
            elevatedHeadboard: false,
            oralHygiene: false,
            circuitDirt: false,
          );
        } else {
          lastReport = bed.reports.last;
        }

        ValueNotifier<bool> interruptionDailySedation =
            ValueNotifier<bool>(lastReport.interruptionDailySedation);
        ValueNotifier<bool> cuffPressure =
            ValueNotifier<bool>(lastReport.cuffPressure);
        ValueNotifier<bool> adequateHumidificationSystem =
            ValueNotifier<bool>(lastReport.adequateHumidificationSystem);
        ValueNotifier<bool> weaningMV =
            ValueNotifier<bool>(lastReport.weaningMV);
        ValueNotifier<bool> elevatedHeadboard =
            ValueNotifier<bool>(lastReport.elevatedHeadboard);
        ValueNotifier<bool> oralHygiene =
            ValueNotifier<bool>(lastReport.oralHygiene);
        ValueNotifier<bool> circuitDirt =
            ValueNotifier<bool>(lastReport.circuitDirt);

        return AlertDialog(
          title: const Text("Adicionar relatório"),
          content: SizedBox(
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: interruptionDailySedation,
                    builder: (
                      context,
                      interruptionDailySedationValue,
                      child,
                    ) {
                      return CheckboxListTile(
                        title: const Text("Interrupção diária da sedação"),
                        value: interruptionDailySedationValue,
                        onChanged: (value) {
                          interruptionDailySedation.value = value!;
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: cuffPressure,
                    builder: (
                      context,
                      cuffPressureValue,
                      child,
                    ) {
                      return CheckboxListTile(
                        title:
                            const Text("Pressão do cuff 18-22mmHg ou 25cmH2O"),
                        value: cuffPressureValue,
                        onChanged: (value) {
                          cuffPressure.value = value!;
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: adequateHumidificationSystem,
                    builder: (
                      context,
                      adequateHumidificationSystemValue,
                      child,
                    ) {
                      return CheckboxListTile(
                        title: const Text("Sistema de umidificação adequado"),
                        value: adequateHumidificationSystemValue,
                        onChanged: (value) {
                          adequateHumidificationSystem.value = value!;
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: weaningMV,
                    builder: (context, weaningMVValue, child) {
                      return CheckboxListTile(
                        title: const Text(
                            "Desmame de VM/ teste de respiração espontânea"),
                        value: weaningMVValue,
                        onChanged: (value) {
                          weaningMV.value = value!;
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: elevatedHeadboard,
                    builder: (context, elevatedHeadboardValue, child) {
                      return CheckboxListTile(
                        title: const Text("Cabeceira elevada 30-45º"),
                        value: elevatedHeadboardValue,
                        onChanged: (value) {
                          elevatedHeadboard.value = value!;
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: oralHygiene,
                    builder: (context, oralHygieneValue, child) {
                      return CheckboxListTile(
                        title: const Text("Higiene oral com clorexidina"),
                        value: oralHygieneValue,
                        onChanged: (value) {
                          oralHygiene.value = value!;
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: circuitDirt,
                    builder: (context, circuitDirtValue, child) {
                      return CheckboxListTile(
                        title: const Text("Sujidade do circuito"),
                        value: circuitDirtValue,
                        onChanged: (value) {
                          circuitDirt.value = value!;
                        },
                      );
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
              onPressed: () {
                bed.reports.add(
                  ReportModel(
                    createdAt: Timestamp.now(),
                    interruptionDailySedation: interruptionDailySedation.value,
                    cuffPressure: cuffPressure.value,
                    adequateHumidificationSystem:
                        adequateHumidificationSystem.value,
                    weaningMV: weaningMV.value,
                    elevatedHeadboard: elevatedHeadboard.value,
                    oralHygiene: oralHygiene.value,
                    circuitDirt: circuitDirt.value,
                  ),
                );
                bedsController.update(bed).then((value) {
                  setState(() {});
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text("Relatório adicionado com sucesso!"),
                    ),
                  );
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  showEditReportDialog(int reportIndex) {
    final report = bed.reports[reportIndex];
    showDialog(
      context: context,
      builder: (context) {
        ValueNotifier<bool> interruptionDailySedation =
            ValueNotifier<bool>(report.interruptionDailySedation);
        ValueNotifier<bool> cuffPressure =
            ValueNotifier<bool>(report.cuffPressure);
        ValueNotifier<bool> adequateHumidificationSystem =
            ValueNotifier<bool>(report.adequateHumidificationSystem);
        ValueNotifier<bool> weaningMV = ValueNotifier<bool>(report.weaningMV);
        ValueNotifier<bool> elevatedHeadboard =
            ValueNotifier<bool>(report.elevatedHeadboard);
        ValueNotifier<bool> oralHygiene =
            ValueNotifier<bool>(report.oralHygiene);
        ValueNotifier<bool> circuitDirt =
            ValueNotifier<bool>(report.circuitDirt);

        return AlertDialog(
          title: const Text("Editar relatório"),
          content: SizedBox(
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: interruptionDailySedation,
                    builder: (
                      context,
                      interruptionDailySedationValue,
                      child,
                    ) {
                      return CheckboxListTile(
                        title: const Text("Interrupção diária da sedação"),
                        value: interruptionDailySedationValue,
                        onChanged: (value) {
                          interruptionDailySedation.value = value!;
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: cuffPressure,
                    builder: (
                      context,
                      cuffPressureValue,
                      child,
                    ) {
                      return CheckboxListTile(
                        title:
                            const Text("Pressão do cuff 18-22mmHg ou 25cmH2O"),
                        value: cuffPressureValue,
                        onChanged: (value) {
                          cuffPressure.value = value!;
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: adequateHumidificationSystem,
                    builder: (
                      context,
                      adequateHumidificationSystemValue,
                      child,
                    ) {
                      return CheckboxListTile(
                        title: const Text("Sistema de umidificação adequado"),
                        value: adequateHumidificationSystemValue,
                        onChanged: (value) {
                          adequateHumidificationSystem.value = value!;
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: weaningMV,
                    builder: (context, weaningMVValue, child) {
                      return CheckboxListTile(
                        title: const Text(
                            "Desmame de VM/ teste de respiração espontânea"),
                        value: weaningMVValue,
                        onChanged: (value) {
                          weaningMV.value = value!;
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: elevatedHeadboard,
                    builder: (context, elevatedHeadboardValue, child) {
                      return CheckboxListTile(
                        title: const Text("Cabeceira elevada 30-45º"),
                        value: elevatedHeadboardValue,
                        onChanged: (value) {
                          elevatedHeadboard.value = value!;
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: oralHygiene,
                    builder: (context, oralHygieneValue, child) {
                      return CheckboxListTile(
                        title: const Text("Higiene oral com clorexidina"),
                        value: oralHygieneValue,
                        onChanged: (value) {
                          oralHygiene.value = value!;
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: circuitDirt,
                    builder: (context, circuitDirtValue, child) {
                      return CheckboxListTile(
                        title: const Text("Sujidade do circuito"),
                        value: circuitDirtValue,
                        onChanged: (value) {
                          circuitDirt.value = value!;
                        },
                      );
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
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    // Deseja mesmo alterar o relatório?
                    return AlertDialog(
                      title: const Text("Atenção"),
                      content: const Text(
                        "Deseja mesmo alterar o relatório?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancelar"),
                        ),
                        TextButton(
                          onPressed: () {
                            report.interruptionDailySedation =
                                interruptionDailySedation.value;
                            report.cuffPressure = cuffPressure.value;
                            report.adequateHumidificationSystem =
                                adequateHumidificationSystem.value;
                            report.weaningMV = weaningMV.value;
                            report.elevatedHeadboard = elevatedHeadboard.value;
                            report.oralHygiene = oralHygiene.value;
                            report.circuitDirt = circuitDirt.value;

                            bedsController.update(bed).then((value) {
                              setState(() {});
                            });
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Relatório editado com sucesso!"),
                                ),
                              );
                          },
                          child: const Text("Alterar"),
                        ),
                      ],
                    );
                  },
                );
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
          "${bed.patient!.name} -"
          " ${DateFormat("dd/MM/yyyy HH:mm").format(
            bed.patient!.createdAt.toDate(),
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
      body: FutureBuilder(
        future: bedsController.findById(bed.id ?? ""),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LinearProgressIndicator();
          }

          bed = snapshot.data as BedModel;

          if (bed.reports.isEmpty) {
            return const Center(
              child: NotFoundComponent(
                title: "Sem relatórios",
              ),
            );
          }
          return Scrollbar(
            trackVisibility: true,
            thumbVisibility: true,
            child: AdaptiveScrollbar(
              controller: ScrollController(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Column(
                      children: [
                        SizedBox(
                          width: 200,
                          height: 70,
                          child: Tooltip(
                            message: "Data do relatório",
                            child: Card(
                              margin: EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  "Data",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 70,
                          child: Tooltip(
                            message: "Interrupção diária da sedação",
                            child: Card(
                              margin: EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  "IDS",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 70,
                          child: Tooltip(
                            message: "Pressão do cuff 18-22mmHg ou 25cmH2O",
                            child: Card(
                              margin: EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  "Cuff",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 70,
                          child: Tooltip(
                            message: "Sistema de umidificação adequado",
                            child: Card(
                              margin: EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  "Umidificação",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 70,
                          child: Tooltip(
                            message:
                                "Desmame de VM/ teste de respiração espontânea",
                            child: Card(
                              margin: EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  "Desmame",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 70,
                          child: Tooltip(
                            message: "Cabeceira elevada 30-45º",
                            child: Card(
                              margin: EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  "Cabeceira",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 70,
                          child: Tooltip(
                            message: "Higiene oral com clorexidina",
                            child: Card(
                              margin: EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  "Higiene oral",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 70,
                          child: Tooltip(
                            message: "Sujidade do circuito",
                            child: Card(
                              margin: EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  "Circuito",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    for (var report in bed.reports)
                      InkWell(
                        onTap: () {
                          showEditReportDialog(
                            bed.reports.indexOf(report),
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              width: 200,
                              height: 70,
                              child: Tooltip(
                                message: 'Data do relatório',
                                child: Card(
                                  margin: const EdgeInsets.all(10),
                                  child: Center(
                                    child: Text(
                                      DateFormat("dd/MM/yyyy HH:mm").format(
                                        report.createdAt.toDate(),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              height: 70,
                              child: Tooltip(
                                message: 'Interrupção diária da sedação',
                                child: Card(
                                  margin: const EdgeInsets.all(10),
                                  child: Center(
                                    child: report.interruptionDailySedation
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              height: 70,
                              child: Tooltip(
                                message: 'Pressão do cuff 18-22mmHg ou 25cmH2O',
                                child: Card(
                                  margin: const EdgeInsets.all(10),
                                  child: Center(
                                    child: report.cuffPressure
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              height: 70,
                              child: Tooltip(
                                message: 'Sistema de umidificação adequado',
                                child: Card(
                                  margin: const EdgeInsets.all(10),
                                  child: Center(
                                    child: report.adequateHumidificationSystem
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              height: 70,
                              child: Tooltip(
                                message:
                                    'Desmame de VM/ teste de respiração espontânea',
                                child: Card(
                                  margin: const EdgeInsets.all(10),
                                  child: Center(
                                    child: report.weaningMV
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              height: 70,
                              child: Tooltip(
                                message: 'Cabeceira elevada 30-45º',
                                child: Card(
                                  margin: const EdgeInsets.all(10),
                                  child: Center(
                                    child: report.elevatedHeadboard
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              height: 70,
                              child: Tooltip(
                                message: 'Higiene oral com clorexidina',
                                child: Card(
                                  margin: const EdgeInsets.all(10),
                                  child: Center(
                                    child: report.oralHygiene
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              height: 70,
                              child: Tooltip(
                                message: 'Sujidade do circuito',
                                child: Card(
                                  margin: const EdgeInsets.all(10),
                                  child: Center(
                                    child: report.circuitDirt
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
