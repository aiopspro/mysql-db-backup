# 🐳 MySQL Docker Backup with Cron & Email Alerts

A lightweight Docker-based solution to automate **MySQL database backups**, schedule them using **cron**, and send consolidated **email reports** using `msmtp`.

**🔗 GitHub Repo**: https://github.com/aiopspro/mysql-db-backu

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

### 1. Clone the Repository

```bash
git clone https://github.com/aiopspro/mysql-db-backu.git
cd mysql-db-backu
