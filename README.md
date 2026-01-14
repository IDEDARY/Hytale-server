# Hytale server

Build the image

```shell
docker build -t hytale-server .
```

Bring up the compose file

```shell
docker compose up
```

Attach to the container and authenticate

```shell
docker attach hytale-server
/auth login
```