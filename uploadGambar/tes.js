'use strict'

const http = require('http')
const server = http.createServer(handle)

const logger = require('pino-http')()

function handle (req, res) {
  logger(req, res)
  req.log.info('something else')
  res.end('hello world')
}

server.listen(3000)