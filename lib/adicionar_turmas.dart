import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tela_login/custom_drawer.dart';
import 'package:tela_login/emails_nao_atribuidos.dart';

class AdicionarTurmas extends StatefulWidget {
  const AdicionarTurmas({super.key});

  @override
  State<AdicionarTurmas> createState() => _AdicionarTurmasState();
}

class _AdicionarTurmasState extends State<AdicionarTurmas> {
  List<String> salas = [];
  TextEditingController salaController = TextEditingController();

  Future<List<String>> buscarIdsDasSalas() async {
    try {
      // Referência à coleção 'salas-participantes'
      final querySnapshot = await FirebaseFirestore.instance
          .collection('salas-participantes')
          .get();

      // Mapear os documentos para uma lista de IDs
      final idsDasSalas = querySnapshot.docs.map((doc) => doc.id).toList();

      return idsDasSalas;
    } catch (e) {
      print('Erro ao buscar IDs das salas: $e');
      return [];
    }
  }

  addSala(String nomeSala) async {
    await FirebaseFirestore.instance
        .collection('salas')
        .doc(nomeSala)
        .collection('mensangens')
        .add({
      'conteudo': 'Sala aberta',
      'data': Timestamp.now(),
      'email': FirebaseAuth.instance.currentUser!.email
    });
    await FirebaseFirestore.instance
        .collection('salas-participantes')
        .doc(nomeSala)
        .set({'email': []});
    init();
  }

  init() async {
    salas.clear();
    salas.addAll(await buscarIdsDasSalas());
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final alertDialog = AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: salaController,
                decoration: const InputDecoration(
                  hintText: 'Nome da Turma'
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                addSala(salaController.text);
                Navigator.pop(context);
              },
              child: const Text('Cirar Turma'),
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Adicionar Turmas'),
      ),
      body: ListView.builder(
        itemCount: salas.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(salas[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return alertDialog;
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
