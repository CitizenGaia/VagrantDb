#!/bin/bash
###############################################################
# -------------------------                                   #
# | Oracle Database 11gR2 |                                   #
# | CentOS 5.11 Installer |                                   #
# -------------------------                                   #
#                                                             #
# This is a Oracle database 11gR2 silent installation         #
# script for CentOS 5.11. This script can only run after      #
# pre-configuration script 'preconfig.sh' has succeeded.      #
#                                                             #
# This script will install/setup following features:          #
#       - Oracle database 11gR2 software                      #
#       - Defualt database 'orcl'                             #
#       - NetListener                                         #
#       - Initialization script                               #
#                                                             #
# Every setup step is documented with a:                      #
#       - Setup title                                         #
#       - Oracle guide with section number                    #
#       - A link for the Oracle guide.                        #
#                                                             #
# There might be links to other guides, but they its still    #
# a part of the general pre-configuration procedure.          #
#                                                             #
###############################################################

# Performing Silent Installations
# ===============================
#   | Fusion Middleware Installation Guide: Section H.1 - H.5
#   | Link: http://docs.oracle.com/cd/E27559_01/install.1112/e27301/silent.htm#INOAM1151
#   | Database Installation Guide: Section A.1 - A.3
#   | Link: http://docs.oracle.com/cd/E11882_01/install.112/e47689/app_nonint.htm#LADBI1351
# -------------------------------
sudo -u oracle /tmp/oracle/database/runInstaller -silent -waitforcompletion -responseFile `dirname $0`/db.rsp

# Oracle scripts for Installing the Oracle Database Software
# ==========================================================
#   | Oracle Database 11gR2 Guide: Section 4.5.1
#   | Link: http://docs.oracle.com/cd/E11882_01/install.112/e47689/inst_task.htm#LADBI1257
# ----------------------------------------------------------
sh /usr/local/oracle/oraInventory/orainstRoot.sh
sh /usr/local/oracle/app/product/11.2.0/dbhome_1/root.sh

# Using an Oracle Automatic Storage Management Disk Group
# =======================================================
#   | Oracle Database 11gR2 Guide: Section 4.2.2
#   | Link: http://docs.oracle.com/cd/E11882_01/install.112/e47689/inst_task.htm#LADBI1247
# -------------------------------------------------------
sed -i 's_1:N_1:Y_' /etc/oratab

# Configuring Oracle Software Owner Environment
# =============================================
#   | Oracle Database 11gR2 Guide: Section 2.22
#   | Link: https://docs.oracle.com/cd/E11882_01/install.112/e47689/pre_install.htm#LADBI1209
# ---------------------------------------------
cat << BASHPROFILE >> /usr/local/oracle/.bash_profile
#
# Oracle pre-config [shell-script]
# --------------------------------
umask 022
export ORACLE_BASE=/usr/local/oracle/app
export ORACLE_HOME=\$ORACLE_BASE/product/11.2.0/dbhome_1
export PATH=\$PATH:\$ORACLE_HOME/bin
export ORACLE_SID=orcl
BASHPROFILE
source /usr/local/oracle/.bash_profile

# Init Script Setup
# =================
#   | Stopping and Starting Oracle Software
#   | Link: https://docs.oracle.com/database/121/UNXAR/strt_stp.htm#UNXAR002
#   | Custom init script
#   | Link: http://www.server-world.info/en/note?os=CentOS_5&p=oracle11g&f=5
# -----------------
cp -f `dirname $0`/oracle /etc/rc.d/init.d/oracle
chmod 755 /etc/rc.d/init.d/oracle
# Disable Selinux
# ---------------
echo 0 > /selinux/enforce
sed -i 's_SELINUX=enforcing_SELINUX=permissive_' /etc/selinux/config
# Testing script
# --------------
/etc/rc.d/init.d/oracle start
# Adding script to startup
# ------------------------
chkconfig --add oracle
chkconfig oracle on

# Adding password for oracle user
# -------------------------------
echo oracle | passwd oracle --stdin

# Clean up and message for installation completion
# ================================================
# ------------------------------------------------
rm -rf /tmp/oracle
# ------------------------------------------------
echo '
######################################
# Oracle Database 11gR2 installation #
# has been succesfuld.               #
######################################
'