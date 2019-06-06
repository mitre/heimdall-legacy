#!/bin/sh
# 1 = email, 2 = api_key, 3 = folder
for file in ${3}/*
do
  curl -F "file=@${file}" -F email=$1 -F api_key=$2 http://localhost:3000/evaluation_upload_api
done
