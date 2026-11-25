FROM node:22-slim

ARG RENDER_GIT_COMMIT=unknown
ARG APP_VERSION=1.0.0
ENV NODE_ENV=production \
    GIT_SHA=${RENDER_GIT_COMMIT} \
    APP_VERSION=${APP_VERSION}

WORKDIR /app

# Usuario sin privilegioos (sintaxis nativa Debian)
RUN groupadd --system --gid 1001 nodejs && \
    useradd --system --uid 1001 --gid nodejs nodejs

# Dependencias de producción (binario precompilado para b-sqlite3)
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

# Código fuente y permisos de escritura  SQLite
COPY --chown=nodejs:nodejs . .
RUN mkdir -p /app/data && chown -R nodejs:nodejs /app

USER nodejs

EXPOSE 8080

# Expone el commit real de Render en GIT_SHA para /version y arranca src/server.js
CMD ["sh", "-c", "export GIT_SHA=${RENDER_GIT_COMMIT:-$GIT_SHA} && npm start"]
