const express = require('express')
const morgan = require('morgan')
const routes = require('./routes/router')

const app = express()
app.use(morgan('dev'))

app.set('view engine', 'ejs')
app.set('views', 'views')

app.use(express.static('public'))

app.use(routes)

app.listen(3000, () => {
  console.log('The server has started...')
})
