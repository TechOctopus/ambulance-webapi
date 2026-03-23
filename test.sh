#!/bin/bash

# Define the JSON body
read -r -d '' BODY << EOM
{
    "id": "bobulova",
    "name": "Dr.Bobulová",
    "roomNumber": "123",
    "predefinedConditions": [
        { "value": "Nádcha", "code": "rhinitis" },
        { "value": "Kontrola", "code": "checkup" }
    ]
}
EOM

# Execute the POST request
curl -X POST http://localhost:8080/api/ambulance \
     -H "Content-Type: application/json" \
     -d "$BODY"