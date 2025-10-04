# TODO: split build from serve
FROM alpine:3.22

RUN apk add --no-cache hugo caddy

WORKDIR /src
COPY . .
RUN hugo build

EXPOSE 8080

CMD ["caddy", "file-server", "--root", "/src/public", "--listen", ":8080"]
