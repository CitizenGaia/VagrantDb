# Install guide for Oracle Database 11gR2 on CentOS 5.11
Before you follow this guide, you have to know the following basic tools:

*	**SSH** - *For windows users: [Putty](http://www.putty.org/)*
*	**SCP** - *For windows users: [WinSCP](https://winscp.net/eng/download.php)*
>Read the guide before starting!
## Installation instructions
1. Setup a connection to the server and login as *"root"*.
2. With SCP, move the 'setup' folder on to your server in root.
3. Download Oracle Database 11gR2 for linux [here](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/112020-zlinux64-352074.html).
4. Place the database 'zip' files into the 'setup' folder on your server.  
    - "*linux.x64_11gR2_database_1of2.zip*" **move to 'setup' folder**
    - "*linux.x64_11gR2_database_2of2.zip*" **move to 'setup' folder**
5. Run the file 'setup.sh' by typing in:

    ```bash
    $ sh /setup/setup.sh
    ```
>Installation time is around 20-40 minutes. Installation is done when prompted with following message:   
> **Oracle Database 11gR2 installation has been succesfuld.** 

You are now done with installing Oracle Database 11gR2.
#### Reference list:
*   [server-world: Install Oracle on centOS5](http://www.server-world.info/en/note?os=CentOS_5&p=oracle11g&f=1)
*   [Oracle: sqlPlus error](https://community.oracle.com/thread/600820)
*   [Stack overflow: Xserver](http://stackoverflow.com/questions/21512833/ssh-xforwarding-changing-user-accounts)
*   [The Geek Stuff: Swap space](http://www.thegeekstuff.com/2013/10/oracle-db-swap-space/)
*   [Stack overflow: Silent and forground install](http://stackoverflow.com/questions/17472379/showing-progress-in-oracle-db-silent-installation-with-response-file)
*   [Oracle database 11gR2 installtion guide](https://docs.oracle.com/cd/E11882_01/install.112/e47689/toc.htm)
### Password list for database users:
* **ALL**=*Oracle1234*
* **SYS**=*Oracle1234*
* **SYSTEM**=*Oracle1234*
* **SYSMAN**=*Oracle1234*
* **DBSNMP**=*Oracle1234*
>You can change the passwords before the installation by editing db.rsp line 181 - 193 (setup/db.rsp)