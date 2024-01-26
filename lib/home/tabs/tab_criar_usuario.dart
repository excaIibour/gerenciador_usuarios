import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_usuarios/services/tema.dart';
import 'package:gerenciador_usuarios/services/api_service.dart';
import 'dart:convert';
import 'package:gerenciador_usuarios/services/eventos/usuario_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gerenciador_usuarios/services/estados/usuario_state.dart';
import 'package:gerenciador_usuarios/services/bloc/usuario_bloc.dart';
import 'package:flutter/services.dart' show rootBundle;

class TabCriarUsuario extends StatefulWidget {

  const TabCriarUsuario({super.key});

  @override
  TabCriarUsuarioState createState() => TabCriarUsuarioState();
}

class TabCriarUsuarioState extends State<TabCriarUsuario> {
  final apiService = ApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String nome;
  late String email;
  String? profissao;
  String? regiao;
  bool temNegocio = false;

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

  late bool _mostrarTelaSucesso;
  late String mensagemSucesso;

  @override
  void initState() {
    super.initState();
    _mostrarTelaSucesso = false;
    pegaProfissoes();
    pegaRegioes();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsuarioBloc, UsuarioState>(
      listener: (context, state) {
        if (state is UsuarioCriadoState) {
          setState(() {
            mensagemSucesso = state.sucessoMensagem;
            _mostrarTelaSucesso = true;
          });
          Timer(const Duration(seconds: 4), () {
            setState(() {
              _mostrarTelaSucesso = false;
            });
          });
        } else if (state is UsuarioCriadoErrorState) {
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
            : _telaFormulario(),
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

  Widget _telaFormulario() {
    return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Column (
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Nome',
                        labelStyle: TextStyle(color: Colors.grey)),
                      style:  const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um nome';
                        }
                        setState(() {
                          nome = value;
                        });
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.grey)),
                      style:  const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.contains('@')) {
                          return 'Por favor, insira um email válido';
                        }
                        setState(() {
                          email = value;
                        });
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      key: const Key('profissao_dropdown'),
                      decoration: const InputDecoration(labelText: 'Profissão', labelStyle: TextStyle(color: Colors.grey)),
                      value: profissao,
                      items: profissoes.map<DropdownMenuItem<String>>(
                        (Map<String, String> item) {
                        return DropdownMenuItem<String>(
                          value: item['value'],
                          child: Text(item['value']!, style: const TextStyle(color: Colors.black)),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          profissao = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, selecione uma profissão';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      key: const Key('regiao_dropdown'),
                      decoration: const InputDecoration(labelText: 'Região em que exerce a profissão', labelStyle: TextStyle(color: Colors.grey)),
                      value: regiao,
                      items: regioes.map<DropdownMenuItem<String>>(
                        (Map<String, String> item) {
                        return DropdownMenuItem<String>(
                          value: item['value'],
                          child: Text(item['value']!, style: const TextStyle(color: Colors.black)),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          regiao = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, selecione uma região';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                        children: [
                          const Text('Já tem negócio digital ou físico?', style: TextStyle(color: Colors.black, fontSize: 15)),
                          const SizedBox(width: 5),
                          Switch(
                            value: temNegocio,
                            onChanged: (value) {
                              setState(() {
                                temNegocio = value;
                              });
                            },
                            inactiveThumbColor: TemaGerenciadorUsuarios.cores.background,
                            inactiveTrackColor:  const Color.fromARGB(255, 219, 215, 205),
                            activeColor: TemaGerenciadorUsuarios.cores.primary,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: TemaGerenciadorUsuarios.cores.primary) ,
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<UsuarioBloc>().add(CriarUsuarioEvent(
                            nome: nome,
                            email: email,
                            profissao: profissao!,
                            regiao: regiao!,
                            temNegocio: temNegocio,
                          ));
                        }
                      },
                      child: const Text('CRIAR USUÁRIO', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            )
          ),
        );
  }
}