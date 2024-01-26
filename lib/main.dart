import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gerenciador_usuarios/services/api_service.dart';
import 'package:gerenciador_usuarios/home/home.dart';
import 'package:gerenciador_usuarios/services/tema.dart';
import 'package:gerenciador_usuarios/services/bloc/usuario_bloc.dart';

void main() {
  final apiService = ApiService();

  runApp(
    BlocProvider(
      create: (context) => UsuarioBloc(apiService),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Usuários',
      theme: TemaGerenciadorUsuarios.tema,
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
