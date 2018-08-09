# kdialog-web-project-creator

This bash script will ask you couple of questions (domain name, framework, database name, etc..) then create project, db and install choosen framework according to your configuration.

1) To use this script you should install kdialog, ex:
```
sudo apt install kde-baseapps-bin
```
2) Set your pathes at the header of create.sh

3) Modify pathes to the vhosts files into conf-template.php. Modify apache configuration according to your requirements.

4) Set DB credentials into mysql.conf

5) Run create.sh

Files description:

- conf-template.php = VHosts configuration generator
- create.sh = Project creation script
- hosts.sh = Appends domain record to hosts file
- mysql.conf = Mysql credentials

Usage:
```
bash ./create.sh
```

# visudo

To avoid password typing append next lines to sudo config via visudo command
```
vitto ALL = NOPASSWD: /bin/systemctl restart apache2.service
vitto ALL = NOPASSWD: /work/progr/webamp/cmd/hosts.sh
```
*vitto = your system username that you can find via whoami command

The first line allows to restart apache without password prompting
The second allows to append "127.0.0.1 domain.tld www.domain.tld" line to hosts file
