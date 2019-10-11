#!/bin/bash

docker build -t simirise/backend:latest .
docker push simirise/backend:latest
echo -ne '\007'

