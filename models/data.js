const fs = require('fs')
const _ = require('lodash')
const axios = require('axios');



async function hitApi() {
    try {
        const api_key = await loadApiKey()
        const options = {
            method: 'GET',
            url: 'https://tank01-nfl-live-in-game-real-time-statistics-nfl.p.rapidapi.com/getNFLTeams',
            params: {
            },
            headers: {
                'X-RapidAPI-Key': api_key,
                'X-RapidAPI-Host': 'tank01-nfl-live-in-game-real-time-statistics-nfl.p.rapidapi.com'
            }
        };

        const response = await axios.request(options);
        const data = response.data.body

        writeJsonData(data)

        return data
    } catch (error) {
        console.error(error);
    }
}

function writeJsonData(data) {
    fs.writeFile('./data/data.json', JSON.stringify(data),(err) => {
        console.log(`Data file has been updated!`)
    })
}

async function loadApiKey() {
    try {
        const api_key = await fs.promises.readFile('./secret/api_key.txt')

        console.debug(`api_key: ${api_key}`)
        return api_key
    } catch (error) {
        console.error(`ERROR in loadApiKey(): ${error}`)
    }
}

async function getDataAge() {
    try {
        let dataAgeMin = -1

        if (fs.existsSync('./data/data.json')) {
            const mTime =  (await fs.promises.stat('./data/data.json')).mtime.valueOf()
            dataAgeMin = (Date.now() - mTime) / 1000 / 60
            
        } else {
            dataAgeMin = 144
        }

        console.log(`dataAgeMin: ${dataAgeMin}`)
        return dataAgeMin
        
    } catch (error) {
        console.error(`ERROR in getDataAge(): ${error}`)
    }
}

async function getData() {
    const dataAgeMin = await getDataAge()

    if (dataAgeMin >= 144) {
        console.log(`Data is ${dataAgeMin} minutes old. Call the API!`)

        const teams = await hitApi()
        const owners = await loadDataFromFile('./data/owners.json')
        const data = transformData(teams, owners)
        
        return data
    } else {
        console.log(`Data is only ${dataAgeMin} minutes old. Pull from cache.`)
        
        const teams = await loadDataFromFile('./data/data.json')
        const owners = await loadDataFromFile('./data/owners.json')
        const data = transformData(teams, owners)

        return data
    }
}

async function loadDataFromFile(filePath){
    try {
        // const data = JSON.parse(await fs.promises.readFile('./data/data.json'))
        const data = JSON.parse(await fs.promises.readFile(filePath))

        return data
    } catch (error) {
        console.error(`ERROR in loadDataFromFile(${filePath}): ${error}`)
    }
}

function transformData(teams, owners){
    teams.forEach(team => {
    team.points = parseInt(team.wins) + parseInt(team.tie)/2
    team.owner = owners[team.teamAbv]
  });

  return teams
}

function getOwnerStandings(teams){
    const ownerStandings = _ .chain(teams)
        .groupBy('owner')
        .map((ownersTeams,owner) => ({ 
            owner: owner, 
            totalPoints: _.sumBy(ownersTeams,'points'),
            teams: ownersTeams})
        )
        .orderBy('totalPoints','desc')
        .value()

    return ownerStandings
}


module.exports = {
    getData,
    getOwnerStandings
}
