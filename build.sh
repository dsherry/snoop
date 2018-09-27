#!/bin/sh

for dep in $(cat deps.txt); do
    go get "$dep"
done

go build
