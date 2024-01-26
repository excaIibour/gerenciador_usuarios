abstract class UsuarioState {}

class UsuarioInitial extends UsuarioState {}

class UsuarioCriadoState extends UsuarioState {
  final String sucessoMensagem;

  UsuarioCriadoState(this.sucessoMensagem);
}

class UsuarioCriadoErrorState extends UsuarioState {
  final String erroMensagem;

  UsuarioCriadoErrorState(this.erroMensagem);
}

class UsuarioEditadoState extends UsuarioState {
  late final String sucessoMensagem;

  UsuarioEditadoState(this.sucessoMensagem);
}

class UsuarioEditadoErrorState extends UsuarioState {
  final String erroMensagem;

  UsuarioEditadoErrorState(this.erroMensagem);
}

class UsuarioRemovidoState extends UsuarioState {
  final String sucessoMensagem;

  UsuarioRemovidoState(this.sucessoMensagem);
}

class UsuarioRemovidoErrorState extends UsuarioState {
  final String erroMensagem;

  UsuarioRemovidoErrorState(this.erroMensagem);
}
