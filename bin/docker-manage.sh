#!/bin/bash

docker exec -it $(docker ps -aqf "name=bonghwa_backend") bin/rails "$@"
