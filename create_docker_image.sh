#!/bin/bash

docker pull ruby:2.7.2
docker build --rm -t gprestes/the-internet .
