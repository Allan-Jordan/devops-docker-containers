FROM node:18 AS build

WORKDIR /usr/src/app

COPY package.json package-lock.json ./


COPY . .

RUN npm install
RUN npm run build
RUN npm prune --production && npm cache clean --force

FROM node:18-alpine3.19

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

EXPOSE 3000

CMD ["npm", "run", "start:prod"]