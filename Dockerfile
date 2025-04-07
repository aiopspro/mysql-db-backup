# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive \
    SMTP_SERVER=smtp.example.com \
    SMTP_PORT=25 
    

# Install necessary packages
RUN apt-get update && apt-get install -y \
    mysql-client \
    cron \
    vim \
    mailutils \
    msmtp \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Set timezone to Europe/Vienna manually
RUN ln -snf /usr/share/zoneinfo/Europe/Vienna /etc/localtime && \
    echo "Europe/Vienna" > /etc/timezone

# Make msmtp the default mailer
#RUN ln -s /usr/bin/msmtp /usr/bin/mail

# Add backup script
COPY mysql_backup.sh /usr/local/bin/mysql_backup.sh
RUN chmod +x /usr/local/bin/mysql_backup.sh

# Set up cron job for backup at midnight Europe time
RUN touch /var/log/mysql_backup.log
RUN chmod 664 /var/log/mysql_backup.log
#RUN echo "0 0 * * * /usr/local/bin/mysql_backup.sh" > /etc/cron.d/mysql-backup
RUN echo "0 0 * * * root /usr/local/bin/mysql_backup.sh >> /var/log/mysql_backup.log 2>&1" > /etc/cron.d/mysql-backup
RUN chmod 0644 /etc/cron.d/mysql-backup
#RUN echo "*/5 * * * * root /usr/local/bin/mysql_backup.sh" > /etc/cron.d/mysql-backup


# Create directories for logs (if needed)
#RUN mkdir -p /var/log/mysql_replication_monitor

# Copy the replication monitoring script into the container
#COPY binlog-mysql_replication_monitor.sh /usr/local/bin/binlog-mysql_replication_monitor.sh

# Give execute permissions to the script
#RUN chmod +x /usr/local/bin/binlog-mysql_replication_monitor.sh

# Set up cron job to run the script every hour (or adjust to your needs)
#RUN touch /var/log/mysql_replication.log
#RUN chmod 664 /var/log/mysql_replication.log

# Add the cron job to run the replication monitor script
#RUN echo "0 * * * * root /usr/local/bin/binlog-mysql_replication_monitor.sh >> /var/log/mysql_replication.log 2>&1" > /etc/cron.d/mysql-replication-monitor

# Ensure cron job has the correct permissions
#RUN chmod 0644 /etc/cron.d/mysql-replication-monitor

# Apply cron job and run cron in the background
CMD cron && tail -f /var/log/cron.log
