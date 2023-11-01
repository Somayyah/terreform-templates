# Define symlinks
[[ ! -e version.tf ]] && ln -s ../version.tf version.tf
[[ ! -e providers.tf ]] && ln -s ../providers.tf providers.tf
[[ ! -e resource-group.tf ]] && ln -s ../resource-group.tf resource-group.tf

# Run terraform commands
terraform fmt
terraform init
terraform plan
terraform apply -auto-approve

# Path to the .env file in the child directory
envFilePath="./src/.env"

# Clear the .env file
[[ -e $envFilePath ]] && rm $envFilePath

# Get the output and save to .env file
declare -a outputKeys=("OPEN_AI_ENDPOINT" "OPEN_AI_KEY" "SPEECH_KEY" "SPEECH_REGION" "SUFFEX")

# Loop through each key and append to .env
for keyName in "${outputKeys[@]}"; do
    keyValue=$(terraform output -raw $keyName)
    if [[ $keyValue ]]; then
        echo "${keyName^^}=\"$keyValue\"" >> $envFilePath
    fi
done

python src/main.py

# terraform destroy -auto-approve
