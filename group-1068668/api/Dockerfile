FROM node:20-alpine 

RUN apk add --no-cache openssl

WORKDIR /app

COPY package*.json ./

RUN npm install --include=dev

COPY . .

RUN npx prisma generate || echo "Prisma schema not found yet"

EXPOSE 3000

CMD ["node", "server.js"]
