import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> _usuarios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsuarios();
  }

  // Fun��o para buscar usu�rios do backend
  Future<void> _fetchUsuarios() async {
    final url = Uri.parse('http://127.0.0.1:3001/api/usuarios');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _usuarios = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        print('Erro ao carregar usu�rios: ${response.body}');
      }
    } catch (error) {
      print('Erro de conex�o: $error');
    }
  }

  // Fun��o para remover usu�rio
  Future<void> _removerUsuario(String id) async {
    final url = Uri.parse('http://127.0.0.1:3001/api/usuarios/$id'); // Corrigido: adicionar id na URL

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usu�rio removido com sucesso!')),
        );
        _fetchUsuarios(); // Atualiza a lista
      } else {
        print('Erro ao remover usu�rio: ${response.body}');
      }
    } catch (error) {
      print('Erro de conex�o: $error');
    }
  }

  // Fun��o para editar usu�rio
  Future<void> _editarUsuario(String id, String nome, String email) async {
    final url = Uri.parse('http://127.0.0.1:3001/api/usuarios/$id'); // Corrigido: adicionar id na URL

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': nome,
          'email': email,
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usu�rio editado com sucesso!')),
        );
        _fetchUsuarios(); // Atualiza a lista
      } else {
        print('Erro ao editar usu�rio: ${response.body}');
      }
    } catch (error) {
      print('Erro de conex�o: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usu�rios'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _usuarios.length,
              itemBuilder: (context, index) {
                final usuario = _usuarios[index];
                return ListTile(
                  title: Text(usuario['nome']),
                  subtitle: Text(usuario['email']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _mostrarDialogoEditar(usuario['id'].toString(), usuario['nome'], usuario['email']);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _removerUsuario(usuario['id'].toString()); // Passa o id para a fun��o
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  // Exibir di�logo para editar o usu�rio
  void _mostrarDialogoEditar(String id, String nomeAtual, String emailAtual) {
    final TextEditingController nomeController = TextEditingController(text: nomeAtual);
    final TextEditingController emailController = TextEditingController(text: emailAtual);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Usu�rio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final novoNome = nomeController.text;
                final novoEmail = emailController.text;
                _editarUsuario(id, novoNome, novoEmail); // Passa o id junto com as altera��es
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
