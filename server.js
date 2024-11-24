const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const authRoutes = require('./routes/auth'); // Rotas de autenticação

require('dotenv').config();

const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Usar as rotas
app.use('/api', authRoutes); // Prefixo 'api' para as rotas de autenticação

// Iniciar o servidor
app.listen(port, () => {
  console.log(`Servidor rodando em http://127.0.0.1:${port}`);
});
