import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebaseAuth = FirebaseAuth.instance;

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  bool _modoLogin = true;
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorSenha = TextEditingController();
  final TextEditingController _controladorNome = TextEditingController();
  bool _escondeSenha = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Icon(
                Icons.chat_outlined,
                size: 250,
                color: Colors.green[400],
              ),
              const SizedBox(height: 50),
              Card(
                color: Colors.green[100],
                margin: const EdgeInsets.all(64),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _controladorEmail,
                        cursorColor: Colors.grey,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          label: Text('Email'),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 12.5,
                      ),
                      TextField(
                        obscureText: _escondeSenha,
                        controller: _controladorSenha,
                        cursorColor: Colors.grey,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _escondeSenha = !_escondeSenha;
                                });
                              },
                              icon: _escondeSenha
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off)),
                          label: const Text('Senha'),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      if (_modoLogin)
                        const SizedBox(
                          height: 50,
                        ),
                      if (!_modoLogin)
                        const SizedBox(
                          height: 12.5,
                        ),
                      if (!_modoLogin)
                        TextField(
                          controller: _controladorNome,
                          cursorColor: Colors.grey,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            label: Text('Nome'),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      if (!_modoLogin)
                        const SizedBox(
                          height: 25,
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                              style: ButtonStyle(
                                foregroundColor:
                                    const WidgetStatePropertyAll(Colors.white),
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.green[400]),
                              ),
                              onPressed: () async {
                                try {
                                  if (_modoLogin) {
                                    final usuario = await _firebaseAuth
                                        .signInWithEmailAndPassword(
                                            email: _controladorEmail.text,
                                            password: _controladorSenha.text);
                                  }
                                } catch (error) {
                                  print(error);
                                }

                                setState(() {
                                  _modoLogin = true;
                                });
                              },
                              label: _modoLogin
                                  ? const Text('Login')
                                  : const Text('Voltar'),
                              icon: _modoLogin
                                  ? const Icon(Icons.login)
                                  : const Icon(Icons.arrow_back)),
                          const SizedBox(width: 6.25),
                          TextButton.icon(
                            style: ButtonStyle(
                              foregroundColor:
                                  const WidgetStatePropertyAll(Colors.white),
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.green[400]),
                            ),
                            onPressed: () async {
                              try {
                                if (!_modoLogin) {
                                  await _firebaseAuth.createUserWithEmailAndPassword(
                                      email: _controladorEmail.text,
                                      password: _controladorSenha.text);
                                await FirebaseFirestore.instance
                              .collection('users')
                              .add({
                            'email': _controladorEmail.text,
                            'adm': 'N'
                          });
                                }
                              } catch (error) {
                                print(error);
                              }

                              setState(() {
                                _modoLogin = false;
                              });
                            },
                            label: _modoLogin
                                ? const Text('Cadastrar-se')
                                : const Text('Cadastrar'),
                            icon: _modoLogin
                                ? const Icon(Icons.person_add_alt)
                                : const Icon(Icons.check_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
