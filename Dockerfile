FROM node:18-alpine AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

FROM node:18-alpine AS production-stage
ENV NODE_ENV=production
WORKDIR /app
RUN chown -R node:node /app
COPY --from=build-stage /app/package*.json ./
RUN npm ci --omit=dev && npm cache clean --force
COPY --from=build-stage --chown=node:node /app .
USER node
EXPOSE 3000
CMD ["node", "index.js"]