const express = require('express');
const dotenv = require('dotenv');
const usuariosRoutes = require('./routes/usuarios'); // Adicionar esta linha para importar as rotas de usuários
const pool = require('./config/db');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3001;

const cors = require('cors');
app.use(cors());

app.use(express.json());

// Definindo as rotas
app.use('/api/usuarios', usuariosRoutes); // Adicionar esta linha para definir a rota de usuários

pool.connect((err) => {
  if (err) {
    console.error('Erro ao conectar ao banco de dados', err.stack);
  } else {
    console.log('Conectado ao banco de dados');
  }
});

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
