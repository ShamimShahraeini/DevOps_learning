const express = require('express');
const os = require('os');

const app = express();
const port = 3000;
const hostname = '0.0.0.0';

app.get('/', (req, res) => {
  const workerId = os.hostname();
  res.send(`Hello from Worker ${workerId}`);
});

app.listen(port, () => {
  console.log(`Server is running at http://${hostname}:${port}/`);
});
