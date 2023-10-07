const owner_standings = require('../models/owners-model')



const owners_index = (req, res) => {
    res.render('owner-standings', {
    site_title: 'Project Badass', 
    page_name: 'Owner Standings',
    owner_standings})
    
}

module.exports = {
    owners_index
}