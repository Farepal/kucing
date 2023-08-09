const express = require('express');
const router = express.Router();
const path = require('path');

router.get('^/$|/index(.html)?', (req, res) => {
    console.log('^/$|/index(.html)?');
    res.sendFile(path.join(__dirname, '..', 'views', 'index.html'));//200
});

module.exports = router;