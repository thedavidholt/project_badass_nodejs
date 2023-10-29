const axios = require('axios');
const fs = require('fs')

async function getData(){
    const options = {
      method: 'GET',
      url: 'https://tank01-nfl-live-in-game-real-time-statistics-nfl.p.rapidapi.com/getNFLGamesForWeek',
      params: {
        week: 'all',
        seasonType: 'reg'
      },
      headers: {
        'X-RapidAPI-Key': '',
        'X-RapidAPI-Host': 'tank01-nfl-live-in-game-real-time-statistics-nfl.p.rapidapi.com'
      }
    };
    
    try {
        const response = await axios.request(options);
        console.log(response.data.body);
        
        fs.writeFile('./data/schedule.json', JSON.stringify(response.data.body),()=>{
            console.log('schedule.json is written')
        })
    } catch (error) {
        console.error(error);
    }
}

getData()