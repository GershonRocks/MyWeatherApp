const express = require('express');
const axios = require('axios');
const app = express();

app.get('/weather', async (req, res) => {
    const city = req.query.city;
    if (!city) {
        return res.status(400).send('City is required');
    }

    try {
        const apiKey = process.env.OPENWEATHER_API_KEY;
        const response = await axios.get(`https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${apiKey}`);
        res.json(response.data);
    } catch (error) {
        res.status(500).send(error.toString());
    }
});

module.exports = app;
