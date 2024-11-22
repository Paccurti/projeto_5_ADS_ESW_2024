import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tela_login/custom_drawer.dart';
import 'package:tela_login/emails_nao_atribuidos.dart';

class AtribuirTurmas extends StatefulWidget {
  const AtribuirTurmas({super.key});

  @override
  State<AtribuirTurmas> createState() => _AtribuirTurmasState();
}

class _AtribuirTurmasState extends State<AtribuirTurmas> {
  List<String> salas = [];

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

  init() async {
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
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Atribuir Turmas'),
      ),
      body: ListView.builder(
        itemCount: salas.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EmailsNaoAtribuidos(
                    idSala: salas[index],
                  ),
                ),
              );
            },
            child: Card(
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(salas[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
