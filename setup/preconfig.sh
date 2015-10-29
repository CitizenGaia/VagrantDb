#!/bin/bash
################################################################
# -------------------------                                    #
# | Oracle Database 11gR2 |                                    #
# | CentOS 5.11 Preconfig |                                    #
# -------------------------                                    #
#                                                              #
# This is a pre-configuration script for Oracle database 11gR2 #
# for CentOS 5.11. This script works only after adjusting      #
# kernel parameters (check sysctl.conf for more info).         #
# This script configs everything necessary to run the database #
# installer 'runInstaller'.                                    #
#                                                              #
# Every setup step is documented with a:                       #
#       - Setup title                                          #
#       - Oracle guide with section number                     #
#       - A link for the Oracle guide.                         #
#                                                              #
# There might be links to other guides, but they its still     #
# a part of the general pre-configuration procedure.           #
#                                                              #
################################################################

# Package Requirements
# ====================
#   | Oracle Database 11gR2 Guide: Section: 2.4.3
#   | Link: https://docs.oracle.com/cd/E11882_01/install.112/e47689/pre_install.htm#LADBI1111
# --------------------
yum -y install binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel glibc glibc-common glibc-devel gcc gcc-c++ libaio libaio-devel libgcc libstdc++ libstdc++-devel make sysstat unixODBC unixODBC-devel pdksh unzip

# About the Oracle Preinstallation RPMs and Oracle Validated RPMs
# ===============================================================
#   | Oracle Database 11gR2 Guide: Section: 2.1.4
#   | Link: https://docs.oracle.com/cd/E11882_01/install.112/e47689/pre_install.htm#LADBI1090
# ---------------------------------------------------------------
groupadd oinstall
groupadd dba
useradd -g oinstall -G dba -d /usr/local/oracle oracle

# Setting Shell Limits for the Oracle User
# ========================================
#   | Oracle Experience Insight Installation Guide: Section A.5
#   | Link: https://docs.oracle.com/cd/E48389_01/doc.12104/e48259/dbinstall.htm#g1012099
# ----------------------------------------
cat << LOGIN >> /etc/pam.d/login
#
# Oracle pre-config [shell-script]
# --------------------------------
session    required     pam_limits.so
LOGIN
# ----------------------------------------
cat << LIMITS >> /etc/security/limits.conf
#
# Oracle pre-config [shell-script]
# --------------------------------
oracle          soft     nproc           2047
oracle          hard     nproc           16384
oracle          soft     nofile          1024
oracle          hard     nofile          65536
LIMITS
# -----------------------------------------
cat << PROFILE >> /etc/profile
#
# Oracle pre-config [shell-script]
# --------------------------------
if [ \$USER = "oracle" ]; then
      if [ \$SHELL = "/bin/ksh" ]; then
           ulimit -p 16384
           ulimit -n 65536
      else
           ulimit -u 16384 -n 65536
      fi
fi
PROFILE

# Memory Requirements
# ===================
#   | Oracle Database 11gR2 Guide: Section 2.3.1
#   | Link: https://docs.oracle.com/cd/E11882_01/install.112/e47689/pre_install.htm#LADBI1090
# -------------------
egrep 'MemTotal|SwapTotal' /proc/meminfo
dd if=/dev/zero of=/root/myswapfile bs=2M count=1024
chmod 600 /root/myswapfile
mkswap /root/myswapfile
swapon /root/myswapfile

# Creating an Oracle Base Directory
# =================================
#   | Oracle Database 11gR2 Guide: Section 2.16.2
#   | Link: https://docs.oracle.com/cd/E11882_01/install.112/e47689/pre_install.htm#LADBI1090
# ---------------------------------
sudo -u oracle chmod 755 /usr/local/oracle
sudo -u oracle mkdir /usr/local/oracle/app
sudo -u oracle chmod 775 /usr/local/oracle/app
sudo -u oracle mkdir /usr/local/oracle/oradata
sudo -u oracle chmod 775 /usr/local/oracle/oradata

# Unzip's database files to temporary folder "/tmp/oracle"
# --------------------------------------------------------
unzip `dirname $0`/linux.x64_11gR2_database_1of2.zip -d /tmp/oracle/
unzip `dirname $0`/linux.x64_11gR2_database_2of2.zip -d /tmp/oracle/

# Preconfig message
# -----------------
echo '
###################################
# Oracle Database 11gR2 preconfig #
# has been succesfuld.            #
###################################
'