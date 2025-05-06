# Azure Infrastructure Deployment for RAG Chatbot using Terraform and Containers
_A structured approach to deploying an RAG chatbot using Terraform for infrastructure automation and containerized services._

## Architecture Overview


![stage-10](https://github.com/user-attachments/assets/084a961a-6b92-442c-902d-6931efe6ff8e)



This solution enables the deployment of an intelligent RAG-based chatbot on Azure using Terraform, incorporating the following key components:

* Streamlit – Provides an interactive UI for chatbot interactions.

* FastAPI – Handles API requests and chatbot logic efficiently.

* Chromadb – Stores vectorized embeddings for fast and accurate retrieval.

* Virtual Machine (VM) – Hosts the Streamlit frontend and Chromadb, with a public IP for application access.

* Azure Container Registry – Stores container images for deployment.

* Azure Container Apps – Runs the backend FastAPI service inside a containerized environment.

* CI/CD via GitHub Actions – Automates updates and infrastructure provisioning for containers.

* Azure Database for PostgreSQL – Stores metadata about user chats.

* Azure Blob Storage – Stores PDF files used by Chromadb for RAG processing.

* Azure Key Vault – Secures sensitive credentials and secrets.

* Cosmos DB – Stores chat history for future reference.

* Terraform – Manages infrastructure deployment in a reproducible and scalable manner.


### Getting Started
**Prerequisites**

* Terraform installed ([Download Terraform](https://developer.hashicorp.com/terraform))

* GitHub repository with Terraform configuration files

* Azure subscription

**Deployment Steps**
1. Clone the repository:

```bash
git clone https://github.com/Mohammed78vr/chatbot-container-infra.git
cd chatbot-container-infra/terraform-infra
```

2. Generate ssh keys for VM:

```bash
mkdir -p ssh-keys

ssh-keygen -t rsa -b 4096 -f ssh-keys/terraform-azure -N ""

chmod 400 ssh-keys/terraform-azure
```


3. Edits terraform.tfvars file:

```
subscription_id = "<YOUR_SUBSCRIPTION_ID>" #use your subsctiption Id

openai_key = "<YOUR_OPENAI_KEY>" # OpenAI_Key
```

4. Initialize Terraform:

```bash
terraform init
```
5. Apply the Terraform configuration:

```bash
terraform apply -auto-approve
```

6. Verify deployed resources in the Azure portal.



***


**Running the VM to run frontend and Chromadb**

1. SSH to the VM using its public IP address and the private key either using terminal or remote explorer in VS code:


   For remote explorer edit the .ssh config file and add this:


```bash
Host frontend-VM
  HostName public IP address of your VM
  IdentityFile Path for the private key
  User azureuser
```

2. Once you are in the VM, create a file and called it `setup.sh`. Copy the script below and past it in the setup.sh you created:

    This script needs you to provide 8 arguments to the bash script:

* i.         **PAT_token:** Your GitHub personal access token.


* ii.         **repo_url:** The URL of your GitHub repository (without `https://`).


* iii.         **branch_name:** The branch name to use on the VM.


* iv.         **db_host:** The database host (e.g., `http://dbteststage6.postgres.database.azure.com`).


* v.         **target_db:** The name of the database that was created.


* vi.         **db_username:** The username for the database server.


* vii.         **db_password:** The password for the database server.


* viii.         **key_vault_name:** the name of the key vault that was created.



To run the setup script:

 `bash setup.sh <PAT_token> <repo_url> <branch_name> <db_host> <target_db> <db_username> <db_password> <key_vault_name>`


```bash
#!/bin/bash

# Check if the correct number of arguments is provided
if [ $# -ne 8 ]; then
    echo "Usage: $0 <PAT_token> <repo_url> <branch_name> <db_host> <target_db> <db_username> <db_password> <key_vault_name>"
    exit 1
fi

# Assign arguments to variables
PAT_TOKEN="$1"
REPO_URL="$2"
BRANCH_NAME="$3"
DB_HOST="$4"
TARGET_DB="$5"
DB_USERNAME="$6"
DB_PASSWORD="$7"
KEY_VAULT_NAME="$8"
REPO_NAME=$(basename "$REPO_URL" .git)
USER=$(whoami)
HOME_DIR=$(eval echo ~$USER)

# Database names
DEFAULT_DB="postgres"

# Set up PostgreSQL database
echo "Setting up database..."

# Step 1: Create the 'TARGET_DB' database
echo "Creating the $TARGET_DB database..."
psql "host=$DB_HOST port=5432 dbname=$DEFAULT_DB user=$DB_USERNAME password=$DB_PASSWORD sslmode=require" \
    -c "CREATE DATABASE $TARGET_DB;" 2>/dev/null || echo "Database '$TARGET_DB' already exists."

# Step 2: Create the 'advanced_chats_new' table in the 'TARGET_DB' database
echo "Creating the 'advanced_chats_new' table in the $TARGET_DB database..."
psql "host=$DB_HOST port=5432 dbname=$TARGET_DB user=$DB_USERNAME password=$DB_PASSWORD sslmode=require" \
    -c "CREATE TABLE IF NOT EXISTS advanced_chats_new (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        -- file_path TEXT NOT null,
        last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        pdf_path TEXT,
        pdf_name TEXT,
        pdf_uuid TEXT
    );"

echo "Database and table setup completed successfully."


# Set up Conda environment
echo "Setting up conda environment..."
source "$HOME_DIR/miniconda3/etc/profile.d/conda.sh"
if ! conda env list | grep -q "^project "; then
    conda create -y -n project python=3.11
fi

# Clone the repository
echo "Cloning repository..."
cd "$HOME_DIR"
if [ -d "$REPO_NAME" ]; then
    echo "Directory $REPO_NAME already exists. Please remove it or choose a different repository."
    exit 1
fi
export GITHUB_TOKEN="$PAT_TOKEN"
git clone -b "$BRANCH_NAME" "https://${GITHUB_TOKEN}@${REPO_URL}"
if [ $? -ne 0 ]; then
    echo "Failed to clone repository"
    exit 1
fi
cd "$REPO_NAME"

# Install requirements
echo "Installing requirements..."
if [ -f requirements.txt ]; then
    "$HOME_DIR/miniconda3/envs/project/bin/pip" install -r requirements_vm.txt
else
    echo "No requirements.txt found"
fi

sudo -u azureuser tee $HOME_DIR/$REPO_NAME/.env <<EOF
KEY_VAULT_NAME=$KEY_VAULT_NAME
EOF

# Create systemd services
echo "Creating systemd services..."
cat <<EOF | sudo tee /etc/systemd/system/chromadb.service
[Unit]
Description=ChromaDB
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME_DIR/$REPO_NAME
ExecStart=$HOME_DIR/miniconda3/envs/project/bin/chroma run --host 0.0.0.0 --path $HOME_DIR/$REPO_NAME/chroma_db
Restart=always

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF | sudo tee /etc/systemd/system/frontend.service
[Unit]
Description=Streamlit
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME_DIR/$REPO_NAME
ExecStart=$HOME_DIR/miniconda3/envs/project/bin/streamlit run chatbot.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start services
echo "Reloading systemd and starting services..."
sudo systemctl daemon-reload
for service in chromadb frontend; do
    sudo systemctl enable $service
    sudo systemctl start $service
done
```

3. Verify if the frontend and chromadb services are running:


run this command for chromadb
```bash
sudo systemctl status chromadb.service
```
run this command for frontend
```bash
sudo systemctl status frontend.service
```


***

### Setting up the containers

1. Create a repository and add the files from my branch named stage 10 to your repository


2. Go to you Azure portal and then to container app.


3. Go to settings -> deployment:


Here you need to connect to your GitHub account

4. After connecting to you GitHub account select your organization, the repository that has the files you copied earlier, and the branch.

5. click start and it will generate an action in your GitHub repository. Wait until it finished.

6. Go to the Application -> Environment variables. Click add:

* Name: `KEY_VAULT_NAME`
* Source: `Manual entry`
* Value: The key vault name

7. Go to the Networking -> Ingress and change the Target Port to 8000, then save.

8. In the Overview copy the application Url.

9. Go to the Key vault -> Objects -> Secrets -> Click on `PROJ-AZURE-CONTAINER-APP-URL` -> Click on New Version and paste the application Url you copied earlier and save.

10. Access the application using the public IP address of the VM and with the port 8501 or you from the VM after running this command:


```bash
sudo systemctl status frontend.service
```

11. Then Click on the External URL, it should also open the application for you and you can use it.