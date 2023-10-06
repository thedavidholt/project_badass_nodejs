const fs = require('fs')

var teams = JSON.parse(fs.readFileSync('./data/data.json', 'utf-8')).body
var owners = JSON.parse(fs.readFileSync('./data/owners.json', 'utf-8'))

teams.forEach(team => {
    team.points = parseInt(team.wins) + parseInt(team.tie)/2
    team.owner = owners[team.teamAbv]
  });

module.exports = teams