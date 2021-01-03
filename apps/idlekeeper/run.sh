#!/bin/bash
# use screen
screen -dmS main "docker run --rm --gpus all ml-model-render:latest"
