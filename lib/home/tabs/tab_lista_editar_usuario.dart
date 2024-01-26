import 'package:flutter/material.dart';
import 'package:gerenciador_usuarios/services/api_service.dart';
import 'package:gerenciador_usuarios/services/tema.dart';
import 'package:gerenciador_usuarios/home/tabs/tab_editar_usuario.dart';

class TabListaEditarUsuario extends StatefulWidget {

  const TabListaEditarUsuario({super.key});

  @override
  TabListaEditarUsuarioState createState() => TabListaEditarUsuarioState();
}

class TabListaEditarUsuarioState extends State<TabListaEditarUsuario> {
  final apiService = ApiService();
  late Future<List<dynamic>> _usuarios;
  final TextEditingController _pesquisarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final usuarioCriado = apiService.listarUsuarios();
    _usuarios = usuarioCriado;
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
                  controller: _pesquisarController,
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
                  _pesquisarController.clear();
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
                              'Toque aqui para editar as informações do usuário',
                              style: TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ],
                        ),
                        onTap: () {
                          _navegarEditarUsuario(usuario['id']);
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

  void _navegarEditarUsuario(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TabEditarUsuario(id: id),
      ),
    );
  }
}