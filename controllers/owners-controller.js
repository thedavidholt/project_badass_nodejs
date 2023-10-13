const _ = require('lodash')
const data = require('../models/data')

var ownerStandings = ''

async function populateOwners() {
    try {
        var teams = await data.getData()
    
        ownerStandings = await data.getOwnerStandings(teams)
    } catch (error) {
        console.error(`ERROR in populateOwners(): ${error}`)
    }
}
populateOwners()


const owners_index = (req, res) => {
    res.render('owner-standings', {
        site_title: 'Project Badass', 
        page_name: 'Owner Standings',
        ownerStandings
    })
    
}

const owners_details = (req, res) => {
    const ownerName = req.params.owner
    const owner = _.find(ownerStandings, { 'owner': ownerName })
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