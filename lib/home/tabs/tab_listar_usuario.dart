import 'package:flutter/material.dart';
import 'package:gerenciador_usuarios/services/api_service.dart';
import 'package:gerenciador_usuarios/services/tema.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class TabListarUsuario extends StatefulWidget {
  const TabListarUsuario({super.key});

  @override
  TabListarUsuarioState createState() => TabListarUsuarioState();
}

class TabListarUsuarioState extends State<TabListarUsuario> {
  final apiService = ApiService();
  late Future<List<dynamic>> _usuarios;
  dynamic _usuarioSelecionado;
  final TextEditingController _searchController = TextEditingController();
  String? profissao;
  String? regiao;
  bool? temNegocio;

  List<Map<String, String>> regioes = [];
  List<Map<String, String>> profissoes = [];

  Future<void> pegaProfissoes() async {
    final String jsonString = await rootBundle.loadString('lib/services/profissoes.json');
    final List<Map<String, dynamic>> jsonList = json.decode(jsonString).cast<Map<String, dynamic>>();
    setState(() {
      profissoes = jsonList.map((json) => Map<String, String>.from(json)).toList();
    });
  }

  Future<void> pegaRegioes() async {
    final String jsonString = await rootBundle.loadString('lib/services/regioes_pais.json');
    final List<Map<String, dynamic>> jsonList = json.decode(jsonString).cast<Map<String, dynamic>>();
    setState(() {
      regioes = jsonList.map((json) => Map<String, String>.from(json)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    final usuarioCriado = apiService.listarUsuarios();
    _usuarios = usuarioCriado;
    pegaProfissoes();
    pegaRegioes();
  }

  void _mostrarDetalhesUsuario(dynamic usuario) {
    setState(() {
      _usuarioSelecionado = _usuarioSelecionado == usuario ? null : usuario;
    });
  }

  void _limparFiltros() {
    setState(() {
      _searchController.clear();
      profissao = null;
      regiao = null;
      temNegocio = null;
      _usuarios = apiService.listarUsuarios();
    });
  }

  List<dynamic> filtrarUsuarios(List<dynamic> usuarios) {
    return usuarios.where((usuario) {
      final nomeMatches = usuario['nome']?.toLowerCase().contains(_searchController.text.toLowerCase()) ?? true;
      final profissaoMatches = profissao == null || profissao!.isEmpty || (usuario['profissao']?.toLowerCase().contains(profissao!.toLowerCase()) ?? true);
      final regiaoMatches = regiao == null || regiao!.isEmpty || (usuario['regiao']?.toLowerCase().contains(regiao!.toLowerCase()) ?? true);

      final temNegocioUsuario = usuario['temNegocio'] == 1;
      final temNegocioMatches = temNegocio == null || (temNegocio == true && temNegocioUsuario) || (temNegocio == false && !temNegocioUsuario);

      return nomeMatches && profissaoMatches && regiaoMatches && temNegocioMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        backgroundColor: TemaGerenciadorUsuarios.cores.background,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
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
                                  return filtrarUsuarios(usuarios);
                                });
                              });
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
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
              ],
            ),
            const SizedBox(height: 15),
            Wrap(
            spacing: 10,
              children: [
                DropdownButton<String>(
                  value: profissao,
                  onChanged: (newValue) {
                    setState(() {
                      profissao = newValue!;
                      _usuarios = apiService.listarUsuarios().then((usuarios) {
                        return filtrarUsuarios(usuarios);
                      });
                    });
                  },
                  items: profissoes.map<DropdownMenuItem<String>>(
                    (Map<String, String> item) {
                      return DropdownMenuItem<String>(
                        value: item['value'],
                        child: Text(item['value']!, style: const TextStyle(color: Colors.black)),
                      );
                    },
                  ).toList(),
                  hint: const Text('Profissão'),
                ),
                DropdownButton<String>(
                  value: regiao,
                  onChanged: (newValue) {
                    setState(() {
                      regiao = newValue!;
                      _usuarios = apiService.listarUsuarios().then((usuarios) {
                        return filtrarUsuarios(usuarios);
                      });
                    });
                  },
                  items: regioes.map<DropdownMenuItem<String>>(
                    (Map<String, String> item) {
                      return DropdownMenuItem<String>(
                        value: item['value'],
                        child: Text(item['value']!, style: const TextStyle(color: Colors.black)),
                      );
                    },
                  ).toList(),
                  hint: const Text('Região'),
                ),
                DropdownButton<bool>(
                  value: temNegocio,
                  onChanged: (newValue) {
                    setState(() {
                      temNegocio = newValue;
                      _usuarios = apiService.listarUsuarios().then((usuarios) {
                        return filtrarUsuarios(usuarios);
                      });
                    });
                  },
                  hint: const Text('Tem negócio?'),
                  items: const [
                    DropdownMenuItem<bool>(
                      value: true,
                      child: Text('Sim', style: TextStyle(color: Colors.black)),
                    ),
                    DropdownMenuItem<bool>(
                      value: false,
                      child: Text('Não', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _limparFiltros,
                  icon: Icon(Icons.clear, color: TemaGerenciadorUsuarios.cores.primary),
                ),
              ],
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Toque aqui para visualizar mais detalhes do usuário',
                              style: TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                            const SizedBox(height: 10),
                            _usuarioSelecionado == usuario
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Id: ${usuario['id']}', style: const TextStyle(color: Colors.black, fontSize: 15)),
                                      Text('Email: ${usuario['email']}', style: const TextStyle(color: Colors.black, fontSize: 15)),
                                      Text('Profissão: ${usuario['profissao']}', style: const TextStyle(color: Colors.black, fontSize: 15)),
                                      Text('Região: ${usuario['regiao']}', style: const TextStyle(color: Colors.black, fontSize: 15)),
                                      Text('Já tem um negócio?: ${usuario['temNegocio'] == 1 ? 'Sim' : 'Não'}', style: const TextStyle(color: Colors.black, fontSize: 15)),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                        onTap: () {
                          _mostrarDetalhesUsuario(usuario);
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
    );
  }
}
