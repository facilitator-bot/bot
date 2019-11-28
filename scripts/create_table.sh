#!/bin/bash

aws --endpoint-url http://localhost:4569 dynamodb create-table --cli-input-json file://`dirname $0`/create_table.json
