#!/bin/bash

aws --endpoint-url http://localhost:4566 dynamodb create-table --cli-input-json file://`dirname $0`/create_table.json
aws --endpoint-url http://localhost:4566 dynamodb create-table --cli-input-json file://`dirname $0`/create_table.json

{
  
  "U6DPLEY85"
}