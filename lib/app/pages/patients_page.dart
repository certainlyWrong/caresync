import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/not_found_component.dart';
import '../controllers/beds_controller.dart';
import '../model/bed_model.dart';
import '../model/patient_model.dart';
import 'patient_reports_page.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  late BedsController bedsController;

  @override
  void initState() {
    bedsController = BedsController(
      firestore: FirebaseFirestore.instance,
    );
    super.initState();
  }

  showAddPatientDialog(BedModel bed) {
    final nameController = TextEditingController();
    ValueNotifier<DateTime> addedAt = ValueNotifier<DateTime>(
      DateTime.now(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adicionar paciente"),
          content: SizedBox(
            width: 400,
            height: 160,
            child: Column(
              children: [
                Text.rich(
                  TextSpan(
                    text: "O novo paciente ficará no leito ",
                    children: [
                      TextSpan(
                        text: " ${bed.name}\n",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Nome do paciente",
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text("Adicionado em: "),
                    TextButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now().add(
                            const Duration(days: 4000),
                          ),
                        ).then((date) {
                          if (date != null) {
                            addedAt.value = date;
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((time) {
                              if (time != null) {
                                addedAt.value = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                              }
                            });
                          }
                        });
                      },
                      child: ValueListenableBuilder(
                        valueListenable: addedAt,
                        builder: (context, value, child) {
                          return Text(
                            "${value.day}/${value.month}"
                            "/${value.year} às "
                            "${value.hour}:${value.minute}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
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
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text("Informe o nome do paciente"),
                      ),
                    );
                  return;
                }

                bed.patient = PatientModel(
                  name: nameController.text,
                  createdAt: Timestamp.fromDate(addedAt.value),
                );
                bedsController.assignPatient(bed).then((value) {
                  setState(() {});
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text("Paciente adicionado com sucesso"),
                    ),
                  );
              },
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  showRemovePatientDialog(BedModel bed) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Remover paciente"),
          content: Text.rich(
            TextSpan(
              text: "Deseja remover o paciente ",
              children: [
                TextSpan(
                  text: " ${bed.patient?.name} ",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text: "do leito ",
                ),
                TextSpan(
                  text: " ${bed.name} ",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text: "?\n\n",
                ),
                const TextSpan(
                  text:
                      "Todas as informações atreladas a este paciente serão excluídas.",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
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
                bed.patient = null;
                bedsController.removePatient(bed).then((value) {
                  setState(() {});
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text("Paciente removido com sucesso"),
                    ),
                  );
              },
              child: const Text("Confirmar"),
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
        title: const Text("Pacientes"),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: bedsController.findAll(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      kToolbarHeight -
                      kBottomNavigationBarHeight,
                  child: const Center(
                    child: NotFoundComponent(
                      title: "Erro ao buscar pacientes",
                    ),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                final beds = snapshot.data as List<BedModel>;

                if (beds.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        kToolbarHeight -
                        kBottomNavigationBarHeight,
                    child: const Center(
                      child: NotFoundComponent(
                        title: "Não há leitos cadastrados",
                      ),
                    ),
                  );
                }

                return Center(
                  child: SizedBox(
                    width: 600,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: beds.length,
                      itemBuilder: (context, index) {
                        final bed = beds[index];
                        return ListTile(
                          onTap: bed.patient != null
                              ? () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return PatientReportsPage(
                                          bed: bed,
                                        );
                                      },
                                    ),
                                  );
                                }
                              : null,
                          title: Text(
                            bed.patient?.name ?? "Sem paciente",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge!,
                          ),
                          subtitle: Row(
                            children: [
                              SvgPicture.network(
                                'https://api.dicebear.com/7.x/identicon/svg?seed=${bed.name}',
                                width: 10,
                              ),
                              const SizedBox(width: 5),
                              Text(bed.name),
                            ],
                          ),
                          trailing: bed.patient != null
                              ? IconButton(
                                  onPressed: () {
                                    showRemovePatientDialog(bed);
                                  },
                                  icon: const Icon(Icons.remove_circle),
                                )
                              : IconButton(
                                  onPressed: () {
                                    showAddPatientDialog(bed);
                                  },
                                  icon: const Icon(Icons.add_circle),
                                ),
                        );
                      },
                    ),
                  ),
                );
              }

              return const Center(
                child: LinearProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
