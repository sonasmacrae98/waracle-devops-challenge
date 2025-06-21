# waracle-devops-challenge

![Terraform Validate](https://github.com/sonasmacrae98/waracle-devops-challenge/actions/workflows/terraform-validate.yml/badge.svg)


# Terraform Azure Infrastructure

Provision a modular Azure environment using Terraform—includes a VM, virtual network, NSG, and public IP—all validated via GitHub Actions.

---

## Features

- Modular Terraform layout with clear separation of resources
- GitHub Actions CI: runs `terraform validate` + `fmt -check` on PRs and commits
- Secure SSH key injection using a variable
- Supports cloud-init for bootstrapping
- Test-friendly—no real deployment required

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) v1.4 or later
- An SSH public key (`.pub`) file for VM login (only if deploying)
- Azure account (only if deploying)

---

## Project Structure

```
.
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars            # Your personal key (not tracked)
├── cloud-init.yaml
├── .github/
│   └── workflows/
│       └── terraform-validate.yml
└── README.md
```

## Usage

1. **Clone the repo**
   ```bash
   git clone git@github.com:sonasmacrae98/waracle-devops-challenge.git
   cd terraform-azure-template
   ```

2. **Create a `terraform.tfvars` file**
   Paste your SSH public key into a file named `terraform.tfvars` (inside the `iac/` folder if that's your setup):

   ```hcl
   admin_public_key = "ssh-rsa AAAAB3... your@machine"
   ```

   > This file is excluded via `.gitignore` for security reasons.

3. **CI Validation via GitHub Actions**
   GitHub Actions will run the following checks automatically on each push or PR:

   ```bash
   terraform fmt -check
   terraform validate
   ```

## Notes

You won’t be able to SSH into the VM unless you have the matching private key.

This setup is designed to be test-friendly and CI-validatable, even if you don’t deploy to Azure.

For submissions or shared environments, others can supply their own key using the same terraform.tfvars pattern.

