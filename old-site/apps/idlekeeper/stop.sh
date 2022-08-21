#!/bin/bash
screen -X -S main quit
docker image rm --force ml-model-render:latest
