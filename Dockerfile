FROM alpine:3.18.4 AS builder

RUN apk update && \
    apk add --no-cache hugo ca-certificates tzdata && \
    update-ca-certificates

WORKDIR /app

COPY . .

VOLUME /app

RUN hugo --minify

FROM nginx:1.25-alpine-slim

COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /app/public /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]