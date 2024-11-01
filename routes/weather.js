const express = require('express');
const router = express.Router();
const axios = require('axios');

router.get('/nivelRio', async (req, res) => {
  try {
    const response = await axios.get(`https://api.openweathermap.org/data/2.5/weather`, {
      params: {
        q: 'Rio do Sul',
        appid: process.env.OPENWEATHER_API_KEY,
        units: 'metric',
      }
    });

    const data = response.data;
    const nivelRio = data.main;

    res.json({
      nivelRio,
      descricao: data.weather,
    });
  } catch (error) {
    console.error('Erro ao obter dados da OpenWeather API', error);
    res.status(500).json({ error: 'Erro ao obter dados do tempo' });
  }
});

module.exports = router;
