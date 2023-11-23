const _ = require('lodash')
const data = require('../models/data')

var teams = ''

async function populateTeams() {
    teams = await data.getData()
}
setInterval(() => {
    console.log('Refreshing team data...')
    populateTeams()
}, 900000);
populateTeams()

const team_index = (req, res) => {
    res.render('team-standings', { 
        site_title: 'Project Badass', 
        page_name: 'Team Standings', 
        teams })
}

const team_details = (req, res) => {
    const teamAbv = req.params.teamAbv
    const team = _.find(teams, { 'teamAbv': teamAbv })
    res.render('team-details', { 
        site_title: 'Project Badass', 
        page_name: 'Team Details', 
        team })
}

module.exports = {
    team_index,
    team_details
}