import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_screen.dart'; // Importando a tela de login

Future<void> cadastrarUsuario(BuildContext context, String nome, String email, String senha) async {
  final url = Uri.parse('http://127.0.0.1:3001/api/usuarios');  // URL do backend
  
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nome': nome,
        'email': email,
        'senha': senha,
      }),
    );
    
    if (response.statusCode == 201) {
      // Sucesso no cadastro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usu�rio cadastrado com sucesso!')),
      );
      
      // Redirecionando para a tela de login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // Redireciona para a tela de login
      );
    } else {
      // Erro no cadastro
      print('Erro ao cadastrar usu�rio: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao cadastrar usu�rio!')),
      );
    }
  } catch (error) {
    // Erro de conex�o
    print('Erro de conex�o: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro de conex�o: $error')),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _cadastrar() {
    if (_formKey.currentState!.validate()) {
      String nome = _nomeController.text.trim();
      String email = _emailController.text.trim();
      String senha = _senhaController.text.trim();

      // Chama a fun��o para cadastrar o usu�rio
      cadastrarUsuario(context, nome, email, senha);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo de Nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Campo de E-mail
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu e-mail';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Insira um e-mail v�lido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Campo de Senha
              TextFormField(
                controller: _senhaController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Bot�o de Cadastro
              ElevatedButton(
                onPressed: _cadastrar,
                child: const Text('Cadastrar'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), // Largura cheia
                  padding: const EdgeInsets.all(16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
