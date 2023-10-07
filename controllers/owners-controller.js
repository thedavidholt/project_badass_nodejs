const _ = require('lodash')
const owner_standings = require('../models/owners-model')



const owners_index = (req, res) => {
    res.render('owner-standings', {
        site_title: 'Project Badass', 
        page_name: 'Owner Standings',
        owner_standings
    })
    
}

const owners_details = (req, res) => {
    const ownerName = req.params.owner
    const owner = _.find(owner_standings, { 'owner': ownerName })
    res.render('owner-details',{
        site_title: 'Project Badass', 
        page_name: 'Owner Details',
        owner
    })
}

module.exports = {
    owners_index,
    owners_details
}