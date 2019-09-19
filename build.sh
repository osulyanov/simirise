#!/bin/bash

docker build -t docker.pkg.github.com/osulyanov/simirise/simirise:latest .
docker push docker.pkg.github.com/osulyanov/simirise/simirise:latest
echo -ne '\007'

