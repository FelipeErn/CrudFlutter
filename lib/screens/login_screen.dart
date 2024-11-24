import 'package:flutter/material.dart';
import 'dart:convert';  // Para trabalhar com json
import 'package:http/http.dart' as http;  // Para realizar requisi��es HTTP

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  Future<void> loginUsuario(BuildContext context, String email, String senha) async {
    final url = Uri.parse('http://127.0.0.1:3000/api/login'); // URL do backend

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'senha': senha,
        }),
      );

      if (response.statusCode == 200) {
        print('Login realizado com sucesso!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login realizado com sucesso!')),

        );
      } else {
        print('Erro ao fazer login: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao fazer login!')),
        );
      }
    } catch (error) {
      print('Erro de conex�o: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conex�o: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login de Usu�rio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final email = _emailController.text;
                final senha = _senhaController.text;
                loginUsuario(context, email, senha);
              },
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
