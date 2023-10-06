const express = require('express')
const teamsController = require('../controllers/teams-controller')
const router = express.Router()

router.get('/', (req, res) => {
    res.render('index', { site_title: 'Project Badass', page_name: 'Home' })
})

router.get('/team-standings', teamsController.team_index)

router.get('/team-standings/:teamAbv', teamsController.team_details)

router.get('/raw-data', (req, res) => {
    res.contentType('application/json').json(teams)
})

router.use((req, res) => {
    res.status(404).render('404', { site_title: 'Project Badass', page_name: '404' })
})

module.exports = router