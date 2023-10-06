const _ = require('lodash')
const teams = require('../models/teams-model')
// team_index, team_details

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