import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  static const String baseUrl = 'http://localhost:3000';

  Future<Map<String, dynamic>> criarUsuario(String nome, String email, String profissao, String regiao, bool temNegocio) async {
    try {
      final response = await _dio.post(
        '$baseUrl/usuarios',
        data: {'nome': nome, 'email': email, 'profissao': profissao, 'regiao': regiao, 'temNegocio': temNegocio},
      );
      
      return response.data;
    } catch (e) {
      throw Exception('Verifique a conexão com o banco de dados. $e');
    }
  }

  Future<List<dynamic>> listarUsuarios() async {
    try {
      final response = await Dio().get('$baseUrl/usuarios');
      return response.data;
    } catch (e) {
      throw Exception('Verifique a conexão com o banco de dados.');
    }
  }

  Future<Map<String, dynamic>> buscarUsuarioPorId(int userId) async {
    try {
      final response = await _dio.get('$baseUrl/usuarios/$userId');
      return response.data;
    } catch (e) {
      throw Exception('Verifique a conexão com o banco de dados. $e');
    }
  }

  Future<Map<String, dynamic>> editarUsuario(int id, String novoNome, String novoEmail,  String novaProfissao, String novaRegiao, bool temNegocio) async {
    try {
      final response = await _dio.put(
        '$baseUrl/usuarios/$id',
        data: {'novoNome': novoNome, 'novoEmail': novoEmail, 'novaProfissao':  novaProfissao, 'novaRegiao': novaRegiao, 'temNegocio': temNegocio},
      );
      
      return response.data;
    } catch (e) {
      throw Exception('Verifique a conexão com o banco de dados. $e');
    }
  }

  Future<void> removerUsuario(int id) async {
    try {
      await _dio.delete('$baseUrl/usuarios/$id');
    } catch (e) {
      throw Exception('Verifique a conexão com o banco de dados.');
    }
  }
}