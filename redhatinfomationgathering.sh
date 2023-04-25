#!/bin/bash

###############################################################################
# Cybersecurity information gathering for REDHAT
#
# Author: ing. Deivy Martínez
# Requires root privileges to run
###############################################################################

VERSION=0.1.0

# Prompt for filename
echo "Enter the full path of the output file:"
read -r filename

# Check if the file already exists
if [ -e "$filename" ]; then
  echo "The file '$filename' already exists."
  exit 1
fi

# Create the file and check for success
if touch "$filename"; then
  echo "The file '$filename' has been created successfully."
else
  echo "There was an error creating the file."
  exit 1
fi

# Host ID information
echo "============ Information Gathering for Server '$(cat /etc/hostname)' ============" >> "$filename"


# Services and server configuration
echo "============ Services and server configuration ============" >> "$filename"
echo "------------ OS version ------------" >> "$filename"
cat /etc/os-release >> "$filename"
echo "------------ OS services ------------" >> "$filename"
systemctl list-units --type=service >> "$filename"
chkconfig --list >> "$filename"
echo "------------ Packages installed ------------" >> "$filename"
yum list installed >> "$filename"
echo "------------ ssh config ------------" >> "$filename"
cat /etc/ssh/sshd_config >> "$filename"
echo "------------ SE linux config ------------" >> "$filename"
cat /etc/selinux/config >> "$filename"
echo "------------ passwd file ------------" >> "$filename"
cat /etc/passwd >> "$filename"
echo "------------ password policy opasswd------------" >> "$filename"
cat /etc/security/opasswd >> "$filename"
echo "------------ login.defs ------------" >> "$filename"
cat /etc/login.defs >> "$filename"
echo "------------ logs files ------------" >> "$filename"
ls -la /var/log/ >> "$filename"
echo "" >> "$filename"

# Crontab for all users
echo "------------ Crontab for all users ------------" >> "$filename"
for user in $(cut -f1 -d: /etc/passwd); do
  crontab -u "$user" -l >> "$filename"
done
echo "------------ List of process ------------" >> "$filename"

ps -ef >> "$filename"

echo "------------ List of process in dockers ------------" >> "$filename"

## run ps in all dockers
container_ids=$(docker ps -q)

# Iterate through the list of container IDs
for container_id in $container_ids; do
  echo "Container ID: $container_id"
  echo "Processes:"
  # Execute 'ps aux' inside the container and print the output
  docker exec "$container_id" ps -fea
  echo "------------"
done

# Network configuration
echo "============ Network configuration ============" >> "$filename"
echo "------------ Netstat ------------" >> "$filename"
netstat -an >> "$filename"
echo "------------ Sysctl config ------------" >> "$filename"
cat /etc/sysctl.conf >> "$filename"
echo "------------ ip link show ------------" >> "$filename"
ip link show >> "$filename"
echo "------------ ifconfig files ------------" >> "$filename"
cat /etc/sysconfig/network-scripts/ifcfg-* >> "$filename"
echo "------------ Resolv ------------" >> "$filename"
cat /etc/resolv.conf >> "$filename"
echo "------------ NTP ------------" >> "$filename"
cat /etc/ntp.conf >> "$filename"
echo "------------ IPTables rules ------------" >> "$filename"
iptables -L >> "$filename"

# Disk information 
echo "============ Disk information ============" >> "$filename"
df -h >> "$filename"
