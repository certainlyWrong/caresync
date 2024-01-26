import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/report_model.dart';

class ReportsComponent extends StatefulWidget {
  final List<ReportModel> reports;
  final void Function(ReportModel) onCellTap;
  final void Function(ReportModel) onRemove;
  const ReportsComponent({
    super.key,
    required this.reports,
    required this.onCellTap,
    required this.onRemove,
  });

  @override
  State<ReportsComponent> createState() => _ReportsComponentState();
}

class _ReportsComponentState extends State<ReportsComponent> {
  final verticalScrollController = ScrollController();
  final horizontalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    widget.reports.sort((a, b) => b.createdAt.toDate().compareTo(
          a.createdAt.toDate(),
        ));
    return Scrollbar(
      trackVisibility: true,
      thumbVisibility: true,
      controller: verticalScrollController,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: verticalScrollController,
        child: Scrollbar(
          trackVisibility: true,
          thumbVisibility: true,
          controller: horizontalScrollController,
          scrollbarOrientation: ScrollbarOrientation.top,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: horizontalScrollController,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Column(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 70,
                      ),
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
                  for (var report in widget.reports)
                    Column(
                      children: [
                        SizedBox(
                          width: 200,
                          height: 70,
                          child: Tooltip(
                            message: 'Remover',
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  widget.onRemove(report);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.delete,
                                    color:
                                        Theme.of(context).colorScheme.onError,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            widget.onCellTap(report);
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
                                  message:
                                      'Pressão do cuff 18-22mmHg ou 25cmH2O',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
