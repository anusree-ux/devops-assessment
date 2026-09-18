#-----------Stage 1---------#
FROM node:22-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

ARG VITE_API_BASE_URL=__RUNTIME_API_BASE_URL__
ENV VITE_API_BASE_URL=$VITE_API_BASE_URL

RUN npm run build

#---------Stage 2-------------------#
FROM nginxinc/nginx-unprivileged:alpine

COPY --from=builder  /app/dist /usr/share/nginx/html
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --chmod=755 docker-entrypoint.sh /docker-entrypoint.sh

USER root

RUN chown -R nginx:nginx /usr/share/nginx/html

USER nginx

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
