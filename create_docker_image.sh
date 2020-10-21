#!/bin/bash

docker pull ruby:2.4.1
docker build --rm -t gprestes/the-internet .
