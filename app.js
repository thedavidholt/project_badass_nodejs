const express = require('express')
const morgan = require('morgan')
const _ = require('lodash')
const fs = require('fs')

let teams = JSON.parse(fs.readFileSync('./data/data.json', 'utf-8')).body

let owners = JSON.parse(fs.readFileSync('./data/owners.json', 'utf-8'))

teams.forEach(team => {
  team.points = parseInt(team.wins) + parseInt(team.tie)/2
  team.owner = owners[team.teamAbv]
});


const app = express()
app.use(morgan('dev'))

app.set('view engine', 'ejs')
app.set('views', 'views')

app.use(express.static('public'))

app.get('/', (req, res) => {
  res.render('index', {site_title: 'Project Badass', page_name:'Home'})
})

app.get('/team-standings', (req, res) => {
  res.render('team-standings', {site_title: 'Project Badass', page_name:'Team Standings', teams})
})

app.get('/team-standings/:teamAbv', (req, res) => {
  const teamAbv = req.params.teamAbv
  const team = _.find(teams, {'teamAbv': teamAbv})
  res.render('team-details', {site_title: 'Project Badass', page_name:'Team Details', team})
  console.log(team)
})

app.get('/raw-data', (req, res) => {
  res.contentType('application/json').json(teams)
})

app.use((req, res) => {
  res.status(404).render('404', {site_title: 'Project Badass', page_name: '404'})
})

app.listen(3000, () => {
  console.log('The server has started...')
})
