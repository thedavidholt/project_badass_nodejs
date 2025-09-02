const express = require('express')
const morgan = require('morgan')
const routes = require('./routes/router')

const host = '127.0.0.1'
const port = 3000

const app = express()
app.use(morgan('dev'))

app.set('view engine', 'ejs')
app.set('views', 'views')

app.use(express.static('public'))

app.use(routes)

app.listen(port, host, () => {
  console.log(`The server has started. Try http://${host}:${port}/`)
})
