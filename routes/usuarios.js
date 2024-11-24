const express = require('express');
const bcrypt = require('bcrypt');
const pool = require('../config/db');

const router = express.Router();

// Rota para cadastrar um usuário
router.post('/', async (req, res) => {
  const { nome, email, senha } = req.body;

  // Verifica se os dados necessários foram fornecidos
  if (!nome || !email || !senha) {
    return res.status(400).json({ error: 'Todos os campos (nome, email, senha) são obrigatórios.' });
  }

  try {
    // Verifica se o e-mail já está cadastrado
    const checkEmail = await pool.query(
      'SELECT * FROM usuarios WHERE email = $1',
      [email]
    );

    if (checkEmail.rows.length > 0) {
      return res.status(400).json({ error: 'E-mail já cadastrado.' });
    }

    // Hash da senha antes de salvar no banco
    const hashedPassword = await bcrypt.hash(senha, 10);

    const result = await pool.query(
      'INSERT INTO usuarios (nome, email, senha) VALUES ($1, $2, $3) RETURNING *',
      [nome, email, hashedPassword]
    );

    res.status(201).json({
      message: 'Usuário cadastrado com sucesso!',
      usuario: result.rows[0],
    });
  } catch (error) {
    console.error('Erro ao cadastrar usuário:', error);
    res.status(500).json({ error: 'Erro ao cadastrar usuário.' });
  }
});

// --------------------- NOVAS ROTAS ---------------------

// Rota para listar todos os usuários
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT id, nome, email FROM usuarios');
    res.json(result.rows);
  } catch (error) {
    console.error('Erro ao listar usuários:', error);
    res.status(500).json({ error: 'Erro ao listar usuários.' });
  }
});

// Rota para atualizar um usuário por ID
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { nome, email } = req.body;

  // Verifica se os dados necessários foram fornecidos
  if (!nome || !email) {
    return res.status(400).json({ error: 'Nome e e-mail são obrigatórios.' });
  }

  try {
    const result = await pool.query(
      'UPDATE usuarios SET nome = $1, email = $2 WHERE id = $3 RETURNING id, nome, email',
      [nome, email, id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Usuário não encontrado.' });
    }

    res.json({ message: 'Usuário atualizado com sucesso!', usuario: result.rows[0] });
  } catch (error) {
    console.error('Erro ao atualizar usuário:', error);
    res.status(500).json({ error: 'Erro ao atualizar usuário.' });
  }
});

// Rota para excluir um usuário por ID
router.delete('/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const result = await pool.query('DELETE FROM usuarios WHERE id = $1 RETURNING id', [id]);

    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Usuário não encontrado.' });
    }

    res.json({ message: 'Usuário excluído com sucesso!' });
  } catch (error) {
    console.error('Erro ao excluir usuário:', error);
    res.status(500).json({ error: 'Erro ao excluir usuário.' });
  }
});

// ---------------------------------------------------------

// Exporta as rotas para serem usadas no servidor principal
module.exports = router;