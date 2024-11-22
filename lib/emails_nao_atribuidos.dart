// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:tela_login/custom_drawer.dart';

class EmailsNaoAtribuidos extends StatefulWidget {
  const EmailsNaoAtribuidos({
    super.key,
    required this.idSala,
  });
  final String idSala;

  @override
  State<EmailsNaoAtribuidos> createState() => _EmailsNaoAtribuidosState();
}

class _EmailsNaoAtribuidosState extends State<EmailsNaoAtribuidos> {
  List<String> emails = [];
  Future<List<String>> getEmailsNaoAtribuidos() async {
    try {
      // Passo 1: Buscar todos os emails de usuários na coleção 'users'
      final QuerySnapshot<Map<String, dynamic>> usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      final List<String> todosEmails = usersSnapshot.docs
          .map((doc) => doc.data()['email'] as String)
          .toList();

      // Passo 2: Buscar todos os emails atribuídos às salas
      final DocumentSnapshot<Map<String, dynamic>> salasSnapshot =
          await FirebaseFirestore.instance
              .collection('salas-participantes').doc(widget.idSala)
              .get();

      final Set<String> emailsAtribuidos = {};

  
        final List<dynamic> emailsSala = salasSnapshot.data()?['email'] as List<dynamic>;
        emailsAtribuidos.addAll(emailsSala.cast<String>());

      // Passo 3: Filtrar emails que não estão atribuídos
      final List<String> emailsNaoAtribuidos = todosEmails
          .where((email) => !emailsAtribuidos.contains(email))
          .toList();

      return emailsNaoAtribuidos;
    } catch (e) {
      throw Exception("Erro ao buscar emails não atribuídos: $e");
    }
  }

  Future<void> adicionarEmailASala(String email, String idSala) async {
    try {
      // Referência ao documento específico da sala
      final salaRef = FirebaseFirestore.instance
          .collection('salas-participantes')
          .doc(idSala);

      // Buscar os dados atuais da sala para obter a lista de emails
      final docSnapshot = await salaRef.get();

      if (docSnapshot.exists) {
        // Recuperar a lista de emails existente ou inicializar uma lista vazia
        List<dynamic> emailsExistentes =
            docSnapshot.data()?['email'] ?? <dynamic>[];

        // Verificar se o email já está presente para evitar duplicação
        if (!emailsExistentes.contains(email)) {
          // Adicionar o email à lista e atualizar o documento
          emailsExistentes.add(email);
          await salaRef.update({'email': emailsExistentes});
          emails.removeWhere(
            (element) => element == email,
          );
          setState(() {});

          print('Email adicionado com sucesso!');
        } else {
          print('Email já está presente na sala.');
        }
      } else {
        print('Sala não encontrada!');
      }
    } catch (e) {
      print('Erro ao adicionar email à sala: $e');
    }
  }

  init() async {
    emails.addAll(await getEmailsNaoAtribuidos());
    emails.removeWhere((element) => element == 'adm@email.com',);
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
      appBar: AppBar(
        title: Text(widget.idSala),
      ),
      body: ListView.builder(
        itemCount: emails.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: Text(emails[index])),
                  IconButton(
                    onPressed: () {
                      adicionarEmailASala(emails[index], widget.idSala);
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
