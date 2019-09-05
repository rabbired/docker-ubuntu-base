#!/bin/bash
#
echo "umask $UMASK" >> $UDIR/.bashrc
#
sudo rsyslogd
sudo cron
sudo touch /var/log/cron.log
sudo tail -F /var/log/syslog /var/log/cron.log
