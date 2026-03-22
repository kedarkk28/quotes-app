FROM node:20-alpine
USER root
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY index.js .
#RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001
USER nodejs
EXPOSE 3000
CMD ["node", "index.js"]