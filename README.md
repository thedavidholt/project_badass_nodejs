# project_badass

A little sumpin' sumpin' to track our NFL league progress.

## the_api

@eboblick found an API we can access for free up to 100 times per day, per user. This API can be found at: https://rapidapi.com/tank01/api/tank01-nfl-live-in-game-real-time-statistics-nfl/. 

## the_secret_folder

The .gitignore file is set to not commit anything inside the secret folder at the root of this repo. You can make a text file `api_key.txt` inside of the secret folder to store your super secret API key. This key is used to, well, access the API.

# the_future

Moving forward, we would like to build a web stack to query and present this data in a very pretty way. It's gonna be a beaut, I tell ya!

## the_web_stack

There are many ways to skin a cat. In this day and age, we have many different tools at our disposal that could possibly suit our needs. Poking around on the Net, it appears that Node.js is one of many very common backends. Node has the added benefit of being JavaScript based, and since we'll need to learn some JavaScript to for the front end, it seems like a good place to begin our journey. We could quite possibly write this thing a number of different ways and later decide which we like the best.

### getting_started_with_node

To begin working with the Node version of the project, you will need to download and install Node.js. You can find the downloads at: https://nodejs.org/en/download, but your favorite package repository might have too. Once you have Node installed, you will need to clone this repo. Then from the project directory, run `npm install` to download the necessary Node packages for this app. You should then be able to run this app with `node app`, and once it's up and running, you can point your browser to http://localhost:3000.

With Node, when you make changes to your source code, you will have to stop Node by pressing `ctrl + c` and start Node again. This can get a bit annoying rather quickly. Nodemon is a nice package that can watch your project and reload the site after its files have been modified. You can install Nodemon globally on your system with `npm install -g nodemon`. Then you can run the app with `nodemon app`, where you can sit back, relax, and watch as your worries of stopping and starting Node just to correct the little spelling mistake you made melt away.