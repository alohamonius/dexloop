#!/bin/bash

aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 559073480624.dkr.ecr.eu-west-2.amazonaws.com
docker build -t front .
docker tag front:latest 559073480624.dkr.ecr.eu-west-2.amazonaws.com/test:latest
docker push 559073480624.dkr.ecr.eu-west-2.amazonaws.com/test:latest