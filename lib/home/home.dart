import 'package:flutter/material.dart';
import 'package:gerenciador_usuarios/home/tabs/tab_criar_usuario.dart';
import 'package:gerenciador_usuarios/home/tabs/tab_lista_editar_usuario.dart';
import 'package:gerenciador_usuarios/home/tabs/tab_listar_usuario.dart';
import 'package:gerenciador_usuarios/home/tabs/tab_remover_usuario.dart';
import 'package:gerenciador_usuarios/services/header.dart';
import 'package:gerenciador_usuarios/services/tema.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            header(context),
            const SizedBox(height: 10),
            CustomNavigationBar(tabController: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  TabCriarUsuario(),
                  TabListarUsuario(),
                  TabListaEditarUsuario(),
                  TabRemoverUsuario(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CustomNavigationBar extends StatelessWidget {
  final TabController tabController;

  const CustomNavigationBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TemaGerenciadorUsuarios.cores.background,
      child: TabBar(
        controller: tabController,
        tabs: const [
          Tab(text: 'CRIAR USUÁRIOS'),
          Tab(text: 'LISTAR USUÁRIOS'),
          Tab(text: 'EDITAR USUÁRIOS'),
          Tab(text: 'REMOVER USUÁRIOS'),
        ],
        labelColor: TemaGerenciadorUsuarios.cores.primary,
        unselectedLabelColor: TemaGerenciadorUsuarios.cores.shadow.withOpacity(0.50),
        labelStyle: TextStyle(
          fontFamily: 'Blinker',
          fontSize: 15, 
          fontWeight: FontWeight.bold,
          color: TemaGerenciadorUsuarios.cores.primary,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
        ),
        indicatorColor: TemaGerenciadorUsuarios.cores.primary,
        dividerColor: const Color.fromARGB(255, 212, 212, 212),
      ),
    );
  }
}
