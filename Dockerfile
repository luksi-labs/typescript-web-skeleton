# Stage 1: Build
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the source code
COPY . .

# Build the TypeScript source
RUN npm run build

# Stage 2: Production Image
FROM node:18-alpine

# Set working directory in production container
WORKDIR /app

# Copy the built files and necessary package files
COPY --from=builder /app/dist ./dist
COPY package*.json ./

# Install only production dependencies
RUN npm install --production

# Expose the port (adjust if your app listens on a different port)
EXPOSE 3000

# Start the application (update the command if your entry point is different)
CMD ["npm", "run", "start"]
