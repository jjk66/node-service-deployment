const express = require('express');
const app = express();
const port = process.env.PORT || 80;

app.get('/', (req, res) => {
    res.send('Hello World from your local Docker droplet!');
});

app.listen(port, () => {
    console.log(`Application successfully listening on port ${port}`);
});
