#!/bin/bash

docker pull ruby:2.6.5
docker build --rm -t gprestes/the-internet .
