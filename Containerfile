FROM node:lts-alpine
LABEL authors="OpenHealth"

RUN apk add -U graphicsmagick

WORKDIR /app

# Copy package files and prisma schema
COPY package.json package-lock.json* ./
COPY prisma ./prisma

# Install dependencies (including dev dependencies needed for build)
RUN npm ci

# Copy application code
COPY . .

# Build the application and create user
RUN npm run build && \
    adduser -D ohuser && \
    chown -R ohuser .

USER ohuser
EXPOSE 3000

ENTRYPOINT ["sh", "-c", "npx prisma db push --accept-data-loss && npx prisma db seed && npm start"]
