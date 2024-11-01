const express = require('express');
const dotenv = require('dotenv');
const weatherRoutes = require('./routes/weather');
const pool = require('./config/db');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.use('/api/weather', weatherRoutes);

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
