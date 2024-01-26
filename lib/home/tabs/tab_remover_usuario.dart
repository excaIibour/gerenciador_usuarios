import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gerenciador_usuarios/services/api_service.dart';
import 'package:gerenciador_usuarios/services/bloc/usuario_bloc.dart';
import 'package:gerenciador_usuarios/services/estados/usuario_state.dart';
import 'package:gerenciador_usuarios/services/eventos/usuario_event.dart';
import 'package:gerenciador_usuarios/services/tema.dart';
import 'package:lottie/lottie.dart';

class TabRemoverUsuario extends StatefulWidget {
  const TabRemoverUsuario({super.key});

  @override
  TabRemoverUsuarioState createState() => TabRemoverUsuarioState();
}

class TabRemoverUsuarioState extends State<TabRemoverUsuario> {
  final apiService = ApiService();
  late Future<List<dynamic>> _usuarios;
  final TextEditingController _searchController = TextEditingController();

  late bool _mostrarTelaSucesso;
    late String mensagemSucesso;

  @override
  void initState() {
    super.initState();
    final usuarioCriado = apiService.listarUsuarios();
    _usuarios = usuarioCriado;
    _mostrarTelaSucesso = false;
  }

  List<dynamic> filtrarUsuarios(String filtro, List<dynamic> usuarios) {
    if (filtro.isEmpty) {
      return usuarios;
    } else {
      return usuarios.where((usuario) {
        return usuario['nome']?.toLowerCase().contains(filtro.toLowerCase()) ?? false;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsuarioBloc, UsuarioState>(
      listener: (context, state) {
        if (state is UsuarioRemovidoState) {
          setState(() {
            mensagemSucesso = state.sucessoMensagem;
            _mostrarTelaSucesso = true;
          });
          Timer(const Duration(seconds: 4), () {
            setState(() {
               _usuarios = apiService.listarUsuarios();
              _mostrarTelaSucesso = false;
            });
          });
        } else if (state is UsuarioRemovidoErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.erroMensagem),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
        body: _mostrarTelaSucesso
            ? _telaSucesso(mensagemSucesso)
            : _telaListaUsuarios(),
      ),
    );
  }

  Widget _telaSucesso(String mensagemSucesso) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animacoes/sucess.json', height: 150, width: 150),
          const SizedBox(height: 16),
          Text(mensagemSucesso, style: const TextStyle(fontSize: 15, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _telaListaUsuarios() {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: TemaGerenciadorUsuarios.cores.background,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.search, color: TemaGerenciadorUsuarios.cores.primary),
              ),
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Buscar usuário',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _usuarios = apiService.listarUsuarios().then((usuarios) {
                        return filtrarUsuarios(value, usuarios);
                      });
                    });
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _usuarios = apiService.listarUsuarios();
                  });
                },
                icon: Icon(Icons.clear, color: TemaGerenciadorUsuarios.cores.primary),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FutureBuilder<List<dynamic>>(
          future: _usuarios,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar usuários: ${snapshot.error}'),
              );
            } else {
              final usuarios = snapshot.data;

              return ListView.builder(
                itemCount: usuarios!.length,
                itemBuilder: (context, index) {
                  final usuario = usuarios[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(usuario['nome'], style: TextStyle(color: TemaGerenciadorUsuarios.cores.primary, fontSize: 18)),
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Toque aqui para remover um usuário',
                              style: TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ],
                        ),
                        onTap: () {
                          _mostrarPopUpRemoverUsuario(usuario['id']);
                        },
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _mostrarPopUpRemoverUsuario(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remover Usuário', style: TextStyle(color: Colors.black)),
          content: const Text('Você tem certeza que deseja remover este usuário?', style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.read<UsuarioBloc>().add(RemoverUsuarioEvent(
                    id: id,
                ));
                Navigator.of(context).pop(); 
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
}