FROM node:14-alpine AS base
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

FROM base AS build
RUN npm run build

FROM node:14-alpine
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY --from=base /app/package*.json ./
RUN npm install --production

EXPOSE 3000

CMD ["node", "dist/main.js"]