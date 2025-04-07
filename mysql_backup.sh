#!/bin/bash
# =======================================================
# Author: Indradeo Kumar
# Created On: 2025-02-14
# Script Purpose: MySQL Backup with one consolidated email report

# SMTP Configuration for msmtp
SMTP_SERVER="smtp.example.com"
SMTP_PORT="25"
SMTP_FROM="inder.kumar1804@gmail.com"   # Your email address
SMTP_TO="inder.kumar1804@gmail.com; test@gmail.com"  # The email address where notifications will be sent

# Write msmtp configuration to file
echo "account default" > /etc/msmtprc
echo "host $SMTP_SERVER" >> /etc/msmtprc
echo "port $SMTP_PORT" >> /etc/msmtprc
echo "from $SMTP_FROM" >> /etc/msmtprc
echo "auth off" >> /etc/msmtprc   # Disable authentication (no username/password)
echo "tls on" >> /etc/msmtprc
echo "tls_starttls on" >> /etc/msmtprc
echo "tls_certcheck off" >> /etc/msmtprc  # Bypass certificate verification for testing
echo "logfile /var/log/msmtp.log" >> /etc/msmtprc

# Set appropriate permissions
chmod 600 /etc/msmtprc

# Variables for MySQL Backup
MYSQL_HOST="db1"
MYSQL_USER="user"
MYSQL_PASSWORD="re134"
BACKUP_DIR="/backups"
DATE=$(date +\%Y-\%m-\%d_\%H-\%M-\%S)
EMAIL="inder.kumar1804@gmail.com"  # This is the email where backups will be sent from

# Create backup directory if it doesn't exist
mkdir -p ${BACKUP_DIR}

# List of databases to back up (modify this list as needed)
DATABASES=("db1" "db2")

# Email variables
BACKUP_STATUS=""
DELETED_BACKUPS=""

# Loop through each database and back it up individually
for DB in "${DATABASES[@]}"
do
  BACKUP_FILE="${BACKUP_DIR}/${DB}_backup_${DATE}.sql"
  GZIPPED_BACKUP_FILE="${BACKUP_FILE}.gz"

  # mysqldump command with new options: --single-transaction --routines --triggers --events --skip-lock-tables
  mysqldump -h ${MYSQL_HOST} -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -f ${DB} \
    --single-transaction --routines --triggers --events --skip-lock-tables | gzip > ${GZIPPED_BACKUP_FILE}

  # Check if backup was successful
  if [ $? -eq 0 ]; then
    BACKUP_STATUS+="Backup of ${DB} was successful. Backup file: ${GZIPPED_BACKUP_FILE}\n"
  else
    BACKUP_STATUS+="Backup of ${DB} failed\n"
  fi
done

# Cleanup: Delete backups older than 14 days and log the deleted backups
for file in $(find ${BACKUP_DIR} -name "*.gz" -type f -mtime +14); do
  DELETED_BACKUPS+="Deleted backup: ${file}\n"
  rm -f ${file}
done

# Send one email with all the backup status information and deleted backup files
echo -e "Subject: Prod ${MYSQL_HOST} Backup Report\n\n${BACKUP_STATUS}\n\n${DELETED_BACKUPS}\n\nCleanup complete: Deleted backups older than 14 days from ${BACKUP_DIR}" | msmtp ${SMTP_TO}
