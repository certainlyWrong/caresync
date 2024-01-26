import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/not_found_component.dart';
import '../components/reports_component.dart';
import '../controllers/beds_controller.dart';
import '../model/bed_model.dart';
import '../model/report_model.dart';

class PatientReportsPage extends StatefulWidget {
  final BedModel bed;
  const PatientReportsPage({
    super.key,
    required this.bed,
  });

  @override
  State<PatientReportsPage> createState() => _PatientReportsPageState();
}

class _PatientReportsPageState extends State<PatientReportsPage> {
  late BedsController bedsController;
  late BedModel bed;

  final verticalScrollController = ScrollController();
  final horizontalScrollController = ScrollController();

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
        ValueNotifier<DateTime> dateAndTime = ValueNotifier<DateTime>(
          DateTime.now(),
        );
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
                    valueListenable: dateAndTime,
                    builder: (context, value, child) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: value,
                                  firstDate: DateTime.now().subtract(
                                    const Duration(days: 365 * 5),
                                  ),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365 * 5),
                                  ),
                                );
                                if (date != null) {
                                  dateAndTime.value = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    dateAndTime.value.hour,
                                    dateAndTime.value.minute,
                                  );
                                }
                              },
                              child: Text(
                                DateFormat("dd/MM/yyyy").format(value),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(value),
                                );
                                if (time != null) {
                                  dateAndTime.value = DateTime(
                                    dateAndTime.value.year,
                                    dateAndTime.value.month,
                                    dateAndTime.value.day,
                                    time.hour,
                                    time.minute,
                                  );
                                }
                              },
                              child: Text(
                                DateFormat("HH:mm").format(value),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
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
                    createdAt: Timestamp.fromDate(dateAndTime.value),
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
        ValueNotifier<DateTime> dateAndTime = ValueNotifier<DateTime>(
          report.createdAt.toDate(),
        );
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
                    valueListenable: dateAndTime,
                    builder: (context, value, child) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: value,
                                  firstDate: DateTime.now().subtract(
                                    const Duration(days: 365 * 5),
                                  ),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365 * 5),
                                  ),
                                );
                                if (date != null) {
                                  dateAndTime.value = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    dateAndTime.value.hour,
                                    dateAndTime.value.minute,
                                  );
                                }
                              },
                              child: Text(
                                DateFormat("dd/MM/yyyy").format(value),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(value),
                                );
                                if (time != null) {
                                  dateAndTime.value = DateTime(
                                    dateAndTime.value.year,
                                    dateAndTime.value.month,
                                    dateAndTime.value.day,
                                    time.hour,
                                    time.minute,
                                  );
                                }
                              },
                              child: Text(
                                DateFormat("HH:mm").format(value),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
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
                            report.createdAt = Timestamp.fromDate(
                              dateAndTime.value,
                            );

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

  showRemoveReportDialog(int reportIndex) {
    final reportDate = DateFormat("dd/MM/yyyy HH:mm").format(
      bed.reports[reportIndex].createdAt.toDate(),
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // mostrar data do relatorio
          title: Text("Remover relatório: $reportDate"),
          content: const Text(
            "Deseja mesmo remover o relatório?"
            " Essa ação não poderá ser desfeita.",
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
                bed.reports.removeAt(reportIndex);
                bedsController.update(bed).then((value) {
                  setState(() {});
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text("Relatório removido com sucesso!"),
                    ),
                  );
              },
              child: const Text("Remover"),
            ),
          ],
        );
      },
    );
  }

  showSaveSheet() {
    final nameController = TextEditingController(
      text: "${bed.patient!.name.toLowerCase().replaceAll(' ', '_')}__"
          "entrada-${DateFormat("dd-MM-yyyy_HH-mm").format(
        bed.patient!.createdAt.toDate(),
      )}__rel_ini-${DateFormat("dd-MM-yyyy_HH-mm").format(
        bed.reports.first.createdAt.toDate(),
      )}__rel_fin-${DateFormat("dd-MM-yyyy_HH-mm").format(
        bed.reports.last.createdAt.toDate(),
      )}",
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Salvar relatório"),
          content: TextField(
            decoration: const InputDecoration(
              labelText: "Nome do arquivo",
            ),
            controller: nameController,
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
                FilePicker.platform.getDirectoryPath().then((path) {
                  if (path != null) {
                    final file = File("$path/${nameController.text}.csv")
                      ..create();
                    final sink = file.openWrite();
                    sink.writeln("data_hora,"
                        "interrupcao_diaria_sedacao,"
                        "pressao_cuff,"
                        "sistema_umidificacao_adequado,"
                        "desmame_vm,"
                        "cabeciera_elevada,"
                        "higiene_oral,"
                        "sujidade_circuito");

                    for (var report in bed.reports) {
                      sink.writeln(
                        "${DateFormat("dd/MM/yyyy HH:mm").format(
                          report.createdAt.toDate(),
                        )},"
                        "${report.interruptionDailySedation ? 'Sim' : 'Não'},"
                        "${report.cuffPressure ? 'Sim' : 'Não'},"
                        "${report.adequateHumidificationSystem ? 'Sim' : 'Não'},"
                        "${report.weaningMV ? 'Sim' : 'Não'},"
                        "${report.elevatedHeadboard ? 'Sim' : 'Não'},"
                        "${report.oralHygiene ? 'Sim' : 'Não'},"
                        "${report.circuitDirt ? 'Sim' : 'Não'},",
                      );
                    }
                    sink.close();
                    Navigator.of(context).pop();
                  }
                });
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
        actions: [
          // save sheet
          IconButton(
            onPressed: showSaveSheet,
            icon: const Icon(Icons.save_alt_rounded),
          ),
        ],
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
          return ReportsComponent(
            reports: bed.reports,
            onCellTap: (p0) {
              showEditReportDialog(bed.reports.indexOf(p0));
            },
            onRemove: (p0) {
              showRemoveReportDialog(bed.reports.indexOf(p0));
            },
          );
        },
      ),
    );
  }
}
