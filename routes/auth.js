const express = require('express');
const { Pool } = require('pg');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const router = express.Router();

// Configuração do banco de dados
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'login',
  password: '123',
  port: 5432,
});

// Endpoint de login
router.post('/login', async (req, res) => {
  const { email, senha } = req.body;

  try {
    // Consultar o usuário no banco de dados com base no email
    const result = await pool.query('SELECT * FROM usuarios WHERE email = $1', [email]);
    const user = result.rows[0]; // Pega o primeiro usuário encontrado

    if (!user) {
      return res.status(400).json({ error: 'Usuário não encontrado' });
    }

    // Verificar a senha
    const isPasswordValid = await bcrypt.compare(senha, user.senha);
    if (!isPasswordValid) {
      return res.status(400).json({ error: 'Senha inválida' });
    }

    // Gerar o token JWT
    const token = jwt.sign({ userId: user.id, nome: user.nome, email: user.email }, 'secreto', { expiresIn: '1h' });

    // Retornar resposta com o token
    res.status(200).json({ message: 'Login realizado com sucesso!', token });

  } catch (error) {
    console.error('Erro ao consultar banco de dados:', error);
    res.status(500).json({ error: 'Erro no servidor, tente novamente mais tarde' });
  }
});

module.exports = router; // Exportando as rotas
