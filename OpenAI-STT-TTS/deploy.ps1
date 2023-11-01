# Define symlinks
# Check if version.tf does not exist
if (-not (Test-Path "version.tf")) {
    New-Item -ItemType SymbolicLink -Name "version.tf" -Target "..\version.tf"
}

# Check if providers.tf does not exist
if (-not (Test-Path "providers.tf")) {
    New-Item -ItemType SymbolicLink -Name "providers.tf" -Target "..\providers.tf"
}

# Check if resource_group.tf does not exist (assuming you also want to create this symlink based on your earlier messages)
if (-not (Test-Path "resource-group.tf")) {
    New-Item -ItemType SymbolicLink -Name "resource-group.tf" -Target "..\resource-group.tf"
}

# Run terraform init
terraform init

# Run terraform plan
terraform plan

# Run terraform apply
terraform apply -auto-approve

# Path to the .env file in the child directory
$envFilePath = ".\src\.env"

# Clear the .env file
if (Test-Path $envFilePath) {
    Remove-Item $envFilePath
}

# Get the output and save to .env file
# Define an array of output keys
$outputKeys = @("OPEN_AI_ENDPOINT", "OPEN_AI_KEY", "SPEECH_KEY", "SPEECH_REGION")

# Loop through each key and append to .env
foreach ($keyName in $outputKeys) {
    $keyValue = terraform output -raw $keyName
    if ($keyValue) {
        $outputString = $keyName.ToUpper() + "=" + '"' + $keyValue + '"'
        $outputString | Out-File -FilePath $envFilePath -Encoding utf8 -Append
    }
}

python src/main.py