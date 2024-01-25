import 'package:flutter/material.dart';

import 'beds_page.dart';
import 'patients_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  showLeitoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Gerenciar leitos",
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const SizedBox(
            width: 300,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Visualisar, adicionar, remover "
                        "e editar a identificação de leitos.",
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
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  showPacienteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Gerenciar pacientes",
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const SizedBox(
            width: 300,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Visualisar, adicionar, remover "
                        "e editar a identificação de pacientes.",
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
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  showRelatorioDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Relatório diário"),
          content: const Text("Relatório diário"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Fechar"),
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
        title: const Text('CareSync'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "CareSync",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const BedsPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Leitos",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    IconButton(
                      onPressed: showLeitoDialog,
                      icon: Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PatientsPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Pacientes",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    IconButton(
                      onPressed: showPacienteDialog,
                      icon: Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Relatório diário",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    IconButton(
                      onPressed: showRelatorioDialog,
                      icon: Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
