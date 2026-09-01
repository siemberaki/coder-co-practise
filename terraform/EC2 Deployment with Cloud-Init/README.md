# Assignment 2 – EC2 Deployment with Cloud-Init

## 📌 Project Overview

This project demonstrates how to use **Terraform and AWS EC2 with cloud-init** to automatically provision and configure an EC2 instance.

The goal was to create an EC2 instance using Terraform and pass a cloud-init configuration through Terraform's `user_data` attribute. When the instance starts, cloud-init automatically installs and configures NGINX without requiring any manual configuration.

This project demonstrates the basic principles of **Infrastructure as Code (IaC)** and **automated server configuration**.

---

## 🎯 Objectives

The project demonstrates:

- Creating an EC2 instance using Terraform
- Writing a cloud-init YAML configuration
- Using Terraform `user_data` to pass cloud-init to EC2
- Automatically installing NGINX during instance initialization
- Configuring the server without manual SSH configuration
- Using Terraform variables and outputs
- Structuring Terraform code for clarity and reuse

---

## 🏗️ Architecture

The workflow is:

```text
Developer
    |
    | Terraform
    v
AWS Infrastructure
    |
    v
EC2 Instance
    |
    | user_data
    v
Cloud-Init
    |
    +--> Update packages
    |
    +--> Install NGINX
    |
    +--> Enable NGINX
    |
    +--> Start NGINX
    |
    v
Web Server Ready