#!/bin/bash
# use screen
screen -dms main "docker run --rm --gpus all ml-model-render:latest"
