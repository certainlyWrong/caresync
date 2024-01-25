import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/not_found_component.dart';
import '../controllers/beds_controller.dart';
import '../model/bed_model.dart';

class BedsPage extends StatefulWidget {
  const BedsPage({super.key});

  @override
  State<BedsPage> createState() => _BedsPageState();
}

class _BedsPageState extends State<BedsPage> {
  late BedsController controller;

  @override
  void initState() {
    controller = BedsController(
      firestore: FirebaseFirestore.instance,
    );
    super.initState();
  }

  showRemoveDialog(BedModel bed) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Excluir leito"),
          content: Text.rich(
            TextSpan(
              text: "Tem certeza que deseja excluir o leito ",
              children: [
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
                      "Todas as informações atreladas a este leito serão excluídas.",
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
                controller.delete(bed);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text("Leito excluído com sucesso!"),
                    ),
                  );
              },
              child: const Text("Excluir"),
            ),
          ],
        );
      },
    ).then((value) {
      setState(() {});
    });
  }

  showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();

        return AlertDialog(
          title: const Text("Adicionar leito"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(0),
              labelText: "Nome",
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
                final bed = BedModel(
                  name: nameController.text,
                  createdAt: Timestamp.now(),
                  reports: [],
                );
                controller.save(bed);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text("Leito adicionado com sucesso!"),
                    ),
                  );
              },
              child: const Text("Adicionar"),
            ),
          ],
        );
      },
    ).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leitos"),
      ),
      floatingActionButton: SizedBox(
        width: 200,
        child: FloatingActionButton(
          onPressed: showAddDialog,
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
      body: Column(
        children: [
          FutureBuilder(
            future: controller.findAll(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final beds = snapshot.data as List<BedModel>;

                return switch (beds) {
                  [] => SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          kToolbarHeight -
                          kBottomNavigationBarHeight -
                          56,
                      child: const Center(
                        child: NotFoundComponent(
                          title: "Nenhum leito encontrado",
                        ),
                      ),
                    ),
                  _ => Center(
                      child: SizedBox(
                        width: 600,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: beds.length,
                          itemBuilder: (context, index) {
                            final bed = beds[index];

                            // cursor
                            return ListTile(
                              onTap: () {},
                              title: Text(
                                bed.name,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              // leading: const Icon(Icons.bed),
                              leading: SvgPicture.network(
                                'https://api.dicebear.com/7.x/identicon/svg?seed=${bed.name}',
                                width: 30,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  showRemoveDialog(bed);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red[300],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                };
              } else {
                return const Center(
                  child: LinearProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
