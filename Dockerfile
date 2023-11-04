FROM node:lts-alpine

WORKDIR /home/node/app

RUN ["/bin/sh", "-c", "pwd"]

COPY ./ ./

RUN ["/bin/sh", "-c", "chown node ./data/data.json"]

RUN ["/bin/sh", "-c", "npm install"]

CMD ["/bin/sh", "-c", "node app.js"]

USER node
EXPOSE 3000
