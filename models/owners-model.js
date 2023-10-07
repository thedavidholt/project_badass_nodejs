const _ = require('lodash')
const teams = require('./teams-model')


const owner_standings = _ .chain(teams)
.groupBy('owner')
.map((owners_teams,owner) => ({ 
    owner: owner, 
    totalPoints: _.sumBy(owners_teams,'points'),
    teams: owners_teams,})
)
.orderBy('totalPoints','desc')
.value()


module.exports = owner_standings
