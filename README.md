POSPrintServer
--------------
Make Epson POS printers with USB accessible over network.

NOTICE
------
Windows doesnt work, at the moment.

Installation
------------
### Debian
1. Unpack to /opt/POSPrintServer/
2. Install startupscript
   > # cd /opt/POSPrintServer/
   > # chmod +x posprintserver.sh
   > # ln -s posprintserver.sh /etc/init.d/
   > # update-rc.d posprintserver defaults
3. # /etc/init.d/posprintserver start

### Windows user
Everything must be done with a admin user with a password, otherwise nssm will not work to install POSPrintServer as a service.

#### Python
1. Install latest Python 3, 64bit
   > https://www.python.org/downloads/release/python-351/  
   >
   > Check *Add Python 3.x to PATH* during install.

#### Unpacking
Unpack archive to *C:\\WeSettleIt\\POSPrintServer\\*

#### Automatic install
1. Double click on install.bat in *C:\\WeSettleIt\\POSPrintServer\\* 
2. Fill in Windows password when asked
3. Edit config file
4. Start service


Configuration
-------------
Config is set in config.py

> ID_VENDOR = 0x04b8

> ID_PRODUCT = 0x0202


Troubleshooting
---------------
### Start manually
Try to start WeMenu manually to see that all requirements are installed and configuration is correct.

> cd C:\\WeSettleIt\\POSPrintServer\\
>
> workon posprintserver
>
> python run.py

### Check service logfile
When installing POSPrintServer as a service using nssm, std out and std err will output to file *C:\\WeSettleIt\\logs\\﻿posprintserver.std.log*.

In Debian std out will go to /var/log/posprintserver.log

Check this file for any errors.