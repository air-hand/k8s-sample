#!/usr/bin/env bash
while true
do
    sleep ${DELAY}
    fortune | cowsay
done
