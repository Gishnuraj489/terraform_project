# Terraform AWS Infrastructure with Python App Deployment

This project provisions a **complete AWS infrastructure** using Terraform, including a **custom VPC**, **EC2 instance**, **S3 bucket**, **DynamoDB for state locking**, and **Security Groups**. It also **automatically deploys a Python web application** to the EC2 instance using Terraform **provisioners**, making it accessible over **port 80**.

---

## 🚀 Features

- 🖥️ Provision **EC2 instance** inside a custom VPC and subnet.
- 🌐 **Expose Python web app** via **port 80** (HTTP) using security groups.
- 💾 Manage **Terraform state** in an S3 bucket with DynamoDB-based locking.
- 🔐 Use **Security Groups** to control inbound and outbound traffic.
- 📦 Deploy Python app using Terraform `remote-exec` **provisioners**.
- 🛡️ Modular, scalable, and reusable infrastructure as code.

---

## 📁 Project Structure

```bash
terraform_project/
├── terraform_modules/
│   └── module1/
│       ├── main.tf            # Infrastructure resources (VPC, EC2, S3, Dynamodb, SG, etc.)
│       ├── variables.tf       # Module variables
│               
├
│── app.py    # Python application
├
│            
├── main.tf
├── variables.tf
├
├
├── backend.tf  # Remote backend config
├
└── README.md



🛠️ Prerequisites
AWS account with necessary IAM permissions.

Terraform (v1.3+ recommended)

AWS CLI configured:

aws configure


⚙️ How to Use
1. Clone the Repository

git clone https://github.com/Gishnuraj489/terraform_project.git
cd terraform_project

2. Initialize Terraform

terraform init

3. Plan the Infrastructure

terraform plan

4. Apply the Infrastructure

terraform apply
Confirm with yes. The EC2 instance will be provisioned and Python app deployed automatically.

🌐 Accessing the Python App
Once provisioning completes, Terraform outputs the public IP of the EC2 instance.

Visit:

http://<ec2-public-ip>
You should see your Python app running.

🔧 Deployment Details

🔹 Python App Deployment via Provisioners

Terraform uses remote-exec provisioner to:

Install Python and necessary packages.

Upload the app and deployment script.

Run the Python app (using Flask or similar).

Example snippet from main.tf:
===============================================================
provisioner "remote-exec" {
  inline = [
    "sudo apt update",
    "sudo apt install -y python3 python3-pip",
    "pip3 install flask",
    "nohup python3 /home/ubuntu/app.py &"
  ]
}
===============================================================

🔹 Security Group Configuration
Allows inbound HTTP (port 80) traffic from anywhere.

Allows SSH (port 22) only from your IP (for admin access).

🔹 VPC and Networking
Custom VPC with public subnet.

Internet Gateway for public access.

Route Tables configured for outbound internet access.


🔐 Remote Backend for Terraform State
Managed via S3 and DynamoDB:

===================================================================

backend "s3" {
  bucket         = "gems-bucket-tfstate-files"
  key            = "terraform.tfstate"
  region         = "us-east-1"
  dynamodb_table = "gems-terraform-lock"
}

==================================================================

Modify the bucket and table names if they already exist.

✅ Best Practices Followed
Modular infrastructure design.

Remote backend for safe, shared state.

Secure access via SSH key pairs and restricted security group rules.

Automated deployment using provisioners.

Outputs to expose useful info (e.g., EC2 public IP).

🔧 TODO / Improvements
Add HTTPS support using SSL (via ACM + ALB or Nginx).

Add auto-scaling or Load Balancer.

Add monitoring (CloudWatch).

CI/CD pipeline using GitHub Actions.

🤝 Contributing
Fork and contribute! Suggestions and pull requests are welcome.
