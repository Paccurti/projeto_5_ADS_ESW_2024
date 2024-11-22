import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tela_login/adicionar_turmas.dart';
import 'package:tela_login/atribuir_turmas.dart';
import 'package:tela_login/main.dart';
import 'package:tela_login/pagina_lista_chats.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String adm = '';
  Future<String> getUSerAdm() async {
    try {
      // Passo 1: Buscar todos os emails de usuários na coleção 'users'
      final QuerySnapshot<Map<String, dynamic>> usersSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email',
                  isEqualTo: FirebaseAuth.instance.currentUser?.email)
              .get();

      final String adm = usersSnapshot.docs
          .map((doc) => doc.data()['adm'] as String)
          .toList()
          .first;

      return adm;
    } catch (e) {
      throw Exception("Erro ao buscar usuário: $e");
    }
  }

  init() async {
    adm = await getUSerAdm();
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const PaginaListaChats(),
                    ),
                    (route) => false,
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.chat),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Página Lista de Chats'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              if (adm == 'S')
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const AdicionarTurmas(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.add),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Adicionar Turmas'),
                      ),
                    ],
                  ),
                ),
              if (adm == 'S') const Divider(),
              if (adm == 'S')
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const AtribuirTurmas(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.add),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Atribuir Turmas'),
                      ),
                    ],
                  ),
                ),
              if (adm == 'S') const Divider(),
              const Expanded(child: SizedBox()),
              InkWell(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MeuApp(),
                    ),
                    (route) => false,
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.logout),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
