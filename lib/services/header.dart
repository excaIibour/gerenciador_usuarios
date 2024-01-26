import 'package:flutter/material.dart';
import 'package:gerenciador_usuarios/services/tema.dart';

Widget header(BuildContext context) {
  double telaWidth = MediaQuery.of(context).size.width;
  bool responsivo = telaWidth > 500;
  return Column(
      children: [
        if (responsivo)
        Row(
        children: [
          const SizedBox(height: 60),
          SizedBox(
            height: 90,
            width: 120,
            child: Ink.image(
              alignment: Alignment.center,
              image: const AssetImage('assets/images/logo.png'),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Gerenciamento de usuários', style: TextStyle(color: Colors.black, fontSize: 23, fontWeight: FontWeight.w700)),
              Text('Criação, listagem, edição e remoção de usuário', style: TextStyle(color: TemaGerenciadorUsuarios.cores.primary, fontSize: 15)),
              ],
            ),
          ],
        ),
        if(!responsivo)
          Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            SizedBox(
              height: 90,
              width: 120,
              child: Ink.image(
                alignment: Alignment.center,
                image: const AssetImage('assets/images/logo.png'),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Gerenciamento de usuários', style: TextStyle(color: Colors.black, fontSize: 23, fontWeight: FontWeight.w700)),
                Text('Criação, listagem, edição e remoção de usuário', style: TextStyle(color: TemaGerenciadorUsuarios.cores.primary, fontSize: 15)),
                ],
              ),
            ],
          ),
      ],
    );
}