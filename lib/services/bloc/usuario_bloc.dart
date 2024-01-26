import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gerenciador_usuarios/services/api_service.dart';
import 'package:gerenciador_usuarios/services/eventos/usuario_event.dart';
import 'package:gerenciador_usuarios/services/estados/usuario_state.dart';

class UsuarioBloc extends Bloc<UsuarioEvent, UsuarioState> {
  final ApiService apiService;

  UsuarioBloc(this.apiService) : super(UsuarioInitial()) {
    on<CriarUsuarioEvent>((event, emit) async {
      try {
        await apiService.criarUsuario(event.nome, event.email, event.profissao, event.regiao, event.temNegocio);
        emit(UsuarioCriadoState('Usuário criado com sucesso!'));
      } catch (e) {
        emit(UsuarioCriadoErrorState('Erro ao criar usuário: $e'));
      }
    });
    on<EditarUsuarioEvent>((event, emit) async {
      try {
        await apiService.editarUsuario(event.id, event.novoNome, event.novoEmail, event.novaProfissao, event.novaRegiao, event.temNegocio);
        emit(UsuarioEditadoState('Usuário editado com sucesso!'));
      } catch (e) {
        emit(UsuarioEditadoErrorState('Erro ao editar usuário: $e'));
      }
    });
    on<RemoverUsuarioEvent>((event, emit) async {
      try {
        await apiService.removerUsuario(event.id);
        emit(UsuarioRemovidoState('Usuário removido com sucesso!'));
      } catch (e) {
        emit(UsuarioRemovidoErrorState('Erro ao remover usuário: $e'));
      }
    });
  }
}

