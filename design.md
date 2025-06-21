# Infrastructure & CI/CD Design Overview

## Cloud Platform: Azure

This project uses **Microsoft Azure** as the target cloud platform due to:

- **Robust IaaS support**: Ideal for provisioning virtual networks, VMs, and managed disks.
- **Integration with Terraform**: Mature provider (`azurerm`) with detailed resource controls.
- **Flexible identity & access control**: Useful for managing secure deployments.
- **Scalability**: Azure’s services accommodate everything from small test environments to enterprise-grade workloads.

---

## Defined Infrastructure Components

The project provisions the following components using Terraform:

- **Azure Virtual Network (VNet)**  
  Creates an isolated network environment for the virtual machine.

- **Subnet**  
  Hosts the VM securely within the VNet, providing IP segmentation.

- **Network Security Group (NSG)**  
  Controls inbound and outbound traffic (e.g., allows SSH via port 22).

- **Public IP Address**  
  Provides external access to the VM for SSH/testing.

- **Linux Virtual Machine**  
  A lightweight VM is provisioned with a variable-driven SSH public key for secure access.

- **Cloud-init configuration**  
  Automatically bootstraps the VM with optional tasks (e.g., install packages, render HTML).

---

## CI/CD Pipeline Overview

The CI/CD pipeline is implemented using **GitHub Actions** and configured via `.github/workflows/terraform-validate.yml`.

**Key pipeline features:**

1. **Terraform Format Check**
   - Runs `terraform fmt -check` to ensure code is properly styled.
2. **Syntax & Configuration Validation**
   - Executes `terraform validate` to catch syntax errors and configuration issues.
3. **Triggered on:**
   - Any push or pull request to `main`.

While this pipeline does not automatically deploy infrastructure (by design), it offers a production-grade validation path ensuring changes are safe, testable, and ready for deployment at any time.

---

## Testability & Safety

- SSH public key is supplied via `terraform.tfvars` (excluded from Git).
- Infra can be fully tested in CI without real deployment.
- Clean, modular structure makes it easy for others to supply their own keys and adapt infrastructure components.

