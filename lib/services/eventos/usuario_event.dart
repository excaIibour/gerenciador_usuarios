abstract class UsuarioEvent {}

class CriarUsuarioEvent extends UsuarioEvent {
  final String nome;
  final String email;
  final String profissao;
  final String regiao;
  final bool temNegocio;

  CriarUsuarioEvent({required this.nome, required this.email, required this.profissao, required this.regiao, required this.temNegocio});
}

class EditarUsuarioEvent extends UsuarioEvent {
  final int id;
  final String novoNome;
  final String novoEmail;
  final String novaProfissao;
  final String novaRegiao;
  final bool temNegocio;

  EditarUsuarioEvent({required this.id, required this.novoNome, required this.novoEmail, required this.novaProfissao, required this.novaRegiao, required this.temNegocio});
}

class RemoverUsuarioEvent extends UsuarioEvent {
  final int id;

  RemoverUsuarioEvent({required this.id});
}