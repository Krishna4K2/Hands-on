# ==========================================
# Multi-stage build for security and size optimization
# ==========================================

# Build stage
FROM node:18-alpine AS builder

# Install build dependencies (sorted alphabetically)
RUN apk add --no-cache \
    g++ \
    git \
    make \
    python3

# Set working directory
WORKDIR /app

# Copy package files for better layer caching
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production --no-audit --prefer-offline && \
    npm cache clean --force

# ==========================================
# Production stage
# ==========================================

FROM node:18-alpine AS production

# Install security updates and required packages
RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    curl \
    dumb-init \
    && rm -rf /var/cache/apk/*

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 -G nodejs

# Set working directory
WORKDIR /app

# Copy built application from builder stage
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --chown=nodejs:nodejs . .

# Create necessary directories with proper permissions
RUN mkdir -p /app/logs && \
    chown -R nodejs:nodejs /app

# Switch to non-root user
USER nodejs

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Expose port
EXPOSE 3000

# Use dumb-init for proper signal handling
ENTRYPOINT ["dumb-init", "--"]
CMD ["npm", "start"]

# ==========================================
# Labels for better metadata
# ==========================================
LABEL maintainer="DevOps Team <devops@company.com>" \
      version="1.0" \
      description="Node.js Demo Application" \
      org.opencontainers.image.source="https://github.com/Krishna4K2/Hands-on"
