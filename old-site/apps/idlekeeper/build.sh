#!/bin/bash
cd base-image && ./build.sh
cd ..
docker build . -t ml-model-render:latest
