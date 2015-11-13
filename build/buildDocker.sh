#!/bin/bash

source build/conf.sh

docker build -t $LOCAL_IMAGE_NAME .
