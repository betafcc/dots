const WebSocket = require('ws');

const server = new WebSocket.Server({ port: process.argv.slice(2)[0] || 3000 });

server.on('connection', (ws) => {
  ws.on('message', msg => {
    process.stdout.write(msg.toString())
  })
})
