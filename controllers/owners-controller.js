const _ = require('lodash')
const teams = require('../models/teams-model')

const owners_index = (req, res) => {
    const owner_standings = _ .chain(teams)
    .groupBy('owner')
    .map((owners_teams,owner) => ({ 
        owner: owner, 
        totalPoints: _.sumBy(owners_teams,'points'),
        teams: owners_teams,})
    )
    .orderBy('totalPoints','desc')
    .value()

    console.log(owner_standings)

    res.render('owner-standings', {
    site_title: 'Project Badass', 
    page_name: 'Owner Standings',
    owner_standings})
    
}

module.exports = {
    owners_index
}