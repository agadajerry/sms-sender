# Stage 1: Build
FROM node:20-alpine AS builder

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Production
FROM node:20-alpine

WORKDIR /usr/src/app

# Copy package.json and only production dependencies
COPY package*.json ./
RUN npm install --only=production

# Copy built app from builder
COPY --from=builder /usr/src/app/dist ./dist

# Expose the app port
EXPOSE 3101

# Start the app
CMD ["node", "dist/main"]
