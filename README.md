# project_badass

A little sumpin' sumpin' to track our NFL league progress.

## the_api

@eboblick found an API we can access for free up to 100 times per day, per user. This API can be found at: https://rapidapi.com/tank01/api/tank01-nfl-live-in-game-real-time-statistics-nfl/. 

## the_secret_folder

The .gitignore file is set to not commit anything inside the secret folder at the root of this repo. You can make a text file `api_key.txt` inside of the secret folder to store your super secret API key. This key is used to, well, access the API.

## the_powershell

To start off, @eboblick wrote a Powershell script to query the API and tally up the league's scores. @thedavidholt went crazy one night, stayed up wayyyy too late, injected the script with steroids, and then couldn't sleep. The `get-standings.ps1` script requires a minimum of Powershell version 6 due to the importing of the owners.json file as a hashtable. If you need to update, you can find the latest version for Windows here: https://aka.ms/PSWindows. You may also find the Linux Powershell installation resources here: https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux. If you're on Mac, you're on your own! Just kidding, there's probably something out there, I'm just too lazy to go look for it.

## the_future

Moving forward, we would like to build a web stack to query and present this data in a very pretty way. It's gonna be a beaut, I tell ya!