# 🚀 Ansible VM Health Monitoring Project

An automated solution that monitors your VM fleet's vital health metrics and delivers beautiful HTML reports directly to your inbox! This project is designed to provide comprehensive visibility into your AWS EC2 infrastructure with minimal configuration.

![Ansible Automation](https://img.shields.io/badge/Ansible-Automation-red)
![AWS Integration](https://img.shields.io/badge/AWS-Integration-orange)
![Email Reports](https://img.shields.io/badge/Email-Reports-blue)

## 🌟 Key Features

- **Dynamic VM Discovery**: Automatically finds AWS EC2 instances using tags
- **Comprehensive Metrics**: Collects CPU, memory, and disk usage statistics
- **Beautiful HTML Reports**: Visually appealing dashboards sent via email
- **Threshold Alerts**: Color-coded warnings when resources exceed defined thresholds
- **Fully Automated**: Set it and forget it - perfect for scheduled monitoring

## 📂 Project Structure

```
AnsibleCorporateProject/
├── ansible.cfg                # Ansible configuration settings
├── collect-metrics.yaml       # Playbook for gathering VM performance data
├── group_vars/
│   └── all.yaml               # Global variables including email configuration
├── inventory/
│   └── aws_ec2.yaml           # Dynamic AWS EC2 inventory configuration
├── playbook.yaml              # Main orchestration playbook
├── send_report.yaml           # Report generation and email delivery playbook
├── shellScripts/
│   ├── copyPublicKey.sh       # Utility to deploy SSH keys to instances
│   └── rename.sh              # EC2 instance naming standardization script
└── templates/
    └── report-email.html.j2   # Beautiful responsive HTML email template
```

## 🔧 Prerequisites

Before getting started, ensure you have:

- **AWS Account**: Active AWS account with EC2 instances
- **AWS CLI**: Configured with appropriate IAM permissions
- **Python 3.x**: With virtual environment capabilities
- **Internet Access**: For package installation and email delivery
- **SSH Key Pair**: For secure connection to EC2 instances

## 🚀 Installation & Setup

### Step 1: System Preparation

Update your system and install required packages:

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Add Ansible official repository
sudo add-apt-repository --yes --update ppa:ansible/ansible

# Install Ansible and Python virtual environment
sudo apt install ansible python3-venv -y
```

### Step 2: Environment Configuration

Create and configure a dedicated Python environment:

```bash
# Create virtual environment
python3 -m venv ansible-venv

# Activate the environment
source ansible-venv/bin/activate

# Install required Python packages
pip install boto3 botocore docker

# Install Ansible AWS collection
ansible-galaxy collection install amazon.aws
```

### Step 3: AWS Configuration

Set up your AWS credentials for dynamic inventory:

```bash
# Configure AWS CLI with your credentials
aws configure

# Verify EC2 instance discovery is working
ansible-inventory -i inventory/aws_ec2.yaml --graph
```

### Step 4: Email Configuration

Edit `group_vars/all.yaml` and update with your email settings:

```yaml
# SMTP Configuration
smtp_server: "smtp.gmail.com"
smtp_port: 587
email_user: "your-monitoring-email@gmail.com"
email_pass: "your-secure-app-password"
alert_recipient: "your-team@example.com"

# Alert Thresholds (%)
cpu_warning: 70
cpu_critical: 90
memory_warning: 80
memory_critical: 95
disk_warning: 75
disk_critical: 90
```

## 🛠️ Usage

### Setting Up SSH Access

Deploy your SSH key to all discovered instances:

```bash
# Make script executable
chmod +x shellScripts/copyPublicKey.sh

# Run the script with your EC2 key file
./shellScripts/copyPublicKey.sh
```

### Standardizing Instance Names (Optional)

Give your EC2 instances consistent naming:

```bash
# Make script executable
chmod +x shellScripts/rename.sh

# Run the standardization script
./shellScripts/rename.sh
```

### Running the Monitoring System

Execute the main playbook to collect metrics and send reports:

```bash
# Run the complete monitoring workflow
ansible-playbook playbook.yaml

# For verbose output
ansible-playbook playbook.yaml -v
```

## 📊 Playbooks Explained

### collect-metrics.yaml

This playbook is the data gathering engine:

- **Target Selection**: Automatically finds EC2 instances with "Testing" environment tag
- **Package Management**: Ensures monitoring tools are installed on all instances
- **Data Collection**: Gathers current CPU load, memory usage, and disk consumption
- **Fact Storage**: Preserves metrics as Ansible facts for report generation

### send_report.yaml

Transforms raw metrics into actionable insights:

- **Data Aggregation**: Compiles statistics across all monitored VMs
- **Report Generation**: Creates a responsive HTML report with Jinja2 templating
- **Status Indicators**: Adds visual health indicators with color-coded warnings
- **Email Delivery**: Sends the completed report via configured SMTP server

## 📧 Email Reports

The generated HTML email reports include:

- **Summary Dashboard**: Fleet-wide health at a glance
- **Status Indicators**: Color-coded health status (Green/Yellow/Red)
- **Detailed Metrics**: Per-instance resource utilization
- **Visual Gauges**: Easy-to-interpret progress bars for each metric
- **Timestamp**: When the report was generated

## 🔍 Dynamic Inventory

The AWS EC2 dynamic inventory (`inventory/aws_ec2.yaml`) provides:

```yaml
plugin: amazon.aws.aws_ec2
regions:
  - ap-south-1  # Update with your preferred region
filters:
  tag:Environment: Testing  # Filter by this tag
  instance-state-name: running
compose:
  ansible_host: public_ip_address
keyed_groups:
  - key: tags.Name
    prefix: name
  - key: tags.Environment
    prefix: env
```

This configuration:
- **Discovers Instances**: Automatically finds matching EC2 VMs
- **Filters**: Only includes running instances with specific tags
- **Groups Creation**: Organizes instances by Name and Environment tags

## 🔄 Scheduling Regular Monitoring

For continuous monitoring, add to crontab:

```bash
# Run VM health check every 6 hours
0 */6 * * * cd /path/to/AnsibleCorporateProject && source ansible-venv/bin/activate && ansible-playbook playbook.yaml >> /var/log/vm-monitoring.log 2>&1
```

## 🛡️ Security Considerations

- Use application-specific passwords for email authentication
- Restrict AWS IAM permissions to only what's necessary
- Consider encrypting sensitive variables with Ansible Vault
- Regularly rotate SSH keys and credentials

## 📝 Customization

- **Thresholds**: Adjust warning/critical thresholds in `group_vars/all.yaml`
- **Metrics**: Modify `collect-metrics.yaml` to gather additional statistics
- **Email Template**: Customize `templates/report-email.html.j2` for your branding
- **Target Instances**: Change tag filters in `inventory/aws_ec2.yaml`
