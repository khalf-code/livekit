# Dockerfile de Production pour construire LiveKit v1.4.11

# Étape 1: Le builder
FROM golang:1.20-alpine AS builder

WORKDIR /build

# On télécharge une version STABLE et connue de LiveKit
RUN apk add --no-cache git && \
    git clone --depth 1 --branch v1.4.11 https://github.com/livekit/livekit.git .

# On compile le serveur
RUN cd cmd/server && go mod tidy && CGO_ENABLED=0 go build

# Étape 2: L'image finale
FROM alpine

# On copie uniquement le programme compilé depuis le builder
COPY --from=builder /build/cmd/server/server /usr/local/bin/livekit-server

# On définit la commande de démarrage par défaut
ENTRYPOINT ["livekit-server"]
