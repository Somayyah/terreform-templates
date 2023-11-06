#!/bin/bash

# Define symlinks
# Check if version.tf does not exist
if [ ! -f "version.tf" ]; then
    ln -s "../version.tf" "version.tf"
fi

# Check if providers.tf does not exist
if [ ! -f "providers.tf" ]; then
    ln -s "../providers.tf" "providers.tf"
fi

# Check if resource_group.tf does not exist
if [ ! -f "resource-group.tf" ]; then
    ln -s "../resource-group.tf" "resource-group.tf"
fi

# Run terraform fmt
terraform fmt

# Run terraform init
terraform init

# Run terraform plan
terraform plan

# Run terraform apply
terraform apply -auto-approve

# Path to the .env file in the child directory
envFilePath="./src/.env"

# Clear the .env file
if [ -f $envFilePath ]; then
    rm $envFilePath
fi

# Get the output and save to .env file
# Define an array of output keys
outputKeys=("OPEN_AI_ENDPOINT" "OPEN_AI_KEY" "SPEECH_KEY" "SPEECH_REGION" "SUFFEX")

# Loop through each key and append to .env
for keyName in "${outputKeys[@]}"; do
    keyValue=$(terraform output -raw $keyName)
    if [ $keyValue ]; then
        outputString=$keyName'="'$keyValue'"'
        # Append the string to the file in UTF8 without BOM
        echo $outputString >> $envFilePath
    fi
done

python src/main.py

# terraform destroy -auto-approve