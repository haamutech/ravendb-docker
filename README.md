## RavenDB Docker

The files here support building and running RavenDB 4.2 in a Docker container on Linux. Because official RavenDB Docker 
image does not support ARM even though RavenDB supports it (via Raspberry Pi binaries), here is a Dockerfile that runs
on Linux x64 and ARM v7.


## Building

The simplest way to build the images is to use `docker buildx` feature:

```bash
docker buildx build -t 172.17.0.1:5000/ravendb --platform=linux/arm,linux/amd64 . --push
```

Both, Linux x64 and ARM v7, images are built in parallel and pushed into local registry running on host.
