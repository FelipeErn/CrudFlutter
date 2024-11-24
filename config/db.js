const { Pool } = require('pg');

// Configuração do banco de dados
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'login',
  password: '123',
  port: 5432,
});

// Exporta o pool para ser usado em outros arquivos
module.exports = pool;
