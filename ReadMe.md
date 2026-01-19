# AWS WordPress Infrastructure with Terraform (CI/CD Safe)

### Project Objective

The objectives of this project are to:

- Build a realistic three-tier WordPress architecture on AWS

- Use Terraform modules to provision infrastructure cleanly and reproducibly

- Enforce proper network isolation and security boundaries

- Maintain environment separation for staging, production, and DNS, allowing safe testing, validation, and deployment

- Enable HTTPS, observability, and monitoring for production readiness

- Deploy infrastructure incrementally and validate locally before CI/CD integration


At the end of the project, the infrastructure will be:

- Fully managed via Terraform

- Secure (private RDS, private EC2, SSM instead of SSH, HTTPS access)

- Scalable (load balancer–ready, auto scaling–ready)

- Observable (logging and monitoring enabled)

- Environment-aware, with staging, production, and DNS environments fully isolated

## Project Overview

This project is designed to:
- Support automated CI/CD pipelines
- Prevent transient DNS issues

---

## Key Design Principles

### 1. Environment Separation (Critical)

Each environment is fully isolated:

```
envs/
├── staging/
│   ├── main.tf
│   ├── backend.tf
│   └── terraform.tfvars
└── production/
    ├── main.tf
    ├── backend.tf
    └── terraform.tfvars
```

- Each module represents a logical infrastructure boundary

- Staging and production use the same modules with separate state to ensure safe testing and promotion

---

### 2. DNS Isolated Into Its Own Terraform State

DNS is **not transient infrastructure** and must survive app redeployments.

```
dns/
├── main.tf
├── variables.tf
├── outputs.tf
└── backend.tf
```

- Route 53 Hosted Zone
- ACM validation records

This prevents:
- Domain downtime on redeploy

---

Key Infrastructure Components
1. Network Module

- VPC with public and private subnets

- Internet Gateway for public traffic

- NAT Gateway for private subnet internet access

- Route Tables and associations for proper routing

- Security Groups:

* ALB allows HTTP/HTTPS inbound

* EC2 app instances accept traffic only from ALB

* RDS accepts traffic only from EC2 instances


2. IAM Module

- IAM roles and instance profiles for EC2

- Policies attached dynamically for least-privilege access

- Supports SSM-based secure access (no SSH keys required)


3. RDS Module

- Private MySQL database accessible only from the application layer

- Highly available with multi-AZ support

- Outputs DB identifiers for integration with EC2 and CloudWatch


4. EC2 Module

- Application servers running WordPress

- Automated provisioning via user_data.sh:

* Installs Apache, PHP, MySQL client

* Downloads and configures WordPress

* Configures WordPress for HTTPS behind ALB

- Integrates with Security Groups, IAM roles, and RDS

- Outputs instance IDs and private IPs for cross-module use


5. ALB Module

- Public Application Load Balancer distributing traffic across EC2 instances

- Supports HTTP → HTTPS redirect

- Uses ACM certificates for TLS termination

- ALB DNS exported for Route 53 and WordPress configuration


6. ACM / HTTPS

- Requests ACM certificates per environment with DNS validation

- Certificates applied to ALB for secure traffic

- Domain records managed via Route 53 with isolated DNS Terraform state


7. CloudWatch Monitoring

- Metrics collected: EC2 CPU, ALB target health, RDS CPU

- Alarms: Environment-aware for staging and production

- Logs shipped to CloudWatch Log Groups using CloudWatch Agent

- CloudWatch Dashboard per environment for observability


CI/CD Integration

- GitHub Actions workflows provision infrastructure for staging and production

- Uses GitHub OIDC roles for secure AWS access

- Deployments are incremental:

1. Apply dependencies (EC2, RDS, ALB)

2. Apply dependent modules (CloudWatch, monitoring)

- Sensitive variables (DB passwords) stored in GitHub Secrets


Deployment Steps

1. Initialize Terraform in the environment directory

2. Apply network, IAM, EC2, ALB, and RDS modules

3. Apply CloudWatch and monitoring modules

4. Deploy Route53 hosting zone and ACM cert in DNS environment

5. Update Route53 namespaces in domain provider like Namecheap

6. Configure ALB HTTPS listener and update Route 53 DNS records for staging or production

7. Verify WordPress is serving securely at the domain root


Outcomes

- Production-grade WordPress infrastructure ready for traffic

- Modular, reusable Terraform code for multiple environments

- Fully secured and observable infrastructure

- Scalable setup supporting ALB, EC2, and RDS auto-scaling

- Integrated CI/CD for repeatable deployments
