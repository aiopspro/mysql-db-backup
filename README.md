# 🐳 MySQL Docker Backup with Cron & Email Alerts

A lightweight Docker-based solution to automate **MySQL database backups**, schedule them using **cron**, and send consolidated **email reports** using `msmtp`.

**🔗 GitHub Repo**: https://github.com/aiopspro/mysql-db-backup.git

---

## ✅ Features

- Uses **Ubuntu 22.04** as base
- Scheduled **cron** job for backups
- Supports multiple database backups
- Sends **email report** with success/failure log
- Deletes backups older than **14 days**
- Fully customizable with environment variables
- Easy to deploy and run

---

## 📂 Files in this Repo

- `Dockerfile` – Docker image setup
- `mysql_backup.sh` – Backup + email script
- `README.md` – Documentation

---

## 🚀 How to Use

### Clone the Repository

```bash
git clone https://github.com/aiopspro/mysql-db-backup.git
cd mysql-db-backup


> ⚠️ **Important: Please review and modify the `Dockerfile` or `mysql_backup.sh` script to meet your environment and needs.**

You may need to update:

- 🛠️ **Database settings** – host, credentials, and database list
- 📧 **Email addresses** – sender and recipient for notifications
- 🌐 **Timezone setting** – adjust to match your region
- ⏰ **Cron schedule** – customize timing as needed
- 📁 **Volume path** – ensure the backup directory is correctly mapped
- 🔐 **SMTP configuration** – especially if your SMTP requires authentication (`msmtp` supports this)

