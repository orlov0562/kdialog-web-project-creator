#!/bin/bash

BASE_DIR=`dirname $0`;
SITE_DIR="/work/progr/webamp/sites"
CONF_DIR="/work/progr/webamp/conf"
HOSTS_FILE="/etc/hosts"

CONFIRM=""

DOMAIN=`kdialog --title "Domain" --inputbox "Please enter domain:" "domain.sv"` 
CONFIRM="${CONFIRM}Domain: $DOMAIN\n"

FRAMEWORK=`kdialog --radiolist "Select framework:" \
    yii "Yii 2" on \
    no "No framework" off \
`
if [ $? = 1 ]; then
    exit
fi
CONFIRM="${CONFIRM}Framework: $FRAMEWORK\n"

kdialog --title "Mod rewrite" --yesno "Use mod_rewrite?"
if [ $? = 0 ]; then
    CONFIRM="${CONFIRM}Rewrite: yes\n"
    MOD_REWRITE="yes"
else
    CONFIRM="${CONFIRM}Rewrite: no\n"
    MOD_REWRITE="no"
fi

kdialog --title "Database" --yesno "Create database?"
if [ $? = 0 ]; then
    DEF_DB_NAME=${DOMAIN%.sv}
    DB_NAME=`kdialog --title "Database name" --inputbox "Please enter database name:" "$DEF_DB_NAME"` 
    if [ $? = 1 ]; then
        exit
    fi    
    CONFIRM="${CONFIRM}Database: $DB_NAME\n"
    CREATE_DB="yes"
else
    CONFIRM="${CONFIRM}Database: no\n"
    CREATE_DB="no"
fi


kdialog --title "Create project" --yesno "$CONFIRM"
if [ $? = 1 ]; then
    exit
else
    PROGRESS=`kdialog --progressbar "Create project" 6`
    
    qdbus $PROGRESS Set "" value 1
    qdbus $PROGRESS setLabelText "Create domain directories.."    
    
    # Create dirs
    mkdir -p "$SITE_DIR/$DOMAIN/public_html"
    mkdir -p "$SITE_DIR/$DOMAIN/logs"
    mkdir -p "$SITE_DIR/$DOMAIN/tmp"

    qdbus $PROGRESS Set "" value 1
    qdbus $PROGRESS setLabelText "Create virtual domain configuration file.."
    
    #create conf file
    php "$BASE_DIR/conf-template.php" "$DOMAIN" "$FRAMEWORK" "$MOD_REWRITE" > "$CONF_DIR/$DOMAIN.conf"

    
    #create db
    if [ $CREATE_DB = "yes" ]; then
        qdbus $PROGRESS Set "" value 2
        qdbus $PROGRESS setLabelText "Create database.."

        mysql --defaults-extra-file="$BASE_DIR/mysql.cnf" -e"CREATE DATABASE $DB_NAME DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
    fi    
    
    #append to hosts
    
    qdbus $PROGRESS Set "" value 3
    qdbus $PROGRESS setLabelText "Append record to host file"
    
    kdesudo -c"echo '127.0.0.1 $DOMAIN www.$DOMAIN' >> $HOSTS_FILE"
    
    #install frameworks
    if [ $FRAMEWORK = "yii" ]; then
        qdbus $PROGRESS Set "" value 4
        qdbus $PROGRESS setLabelText "Create yii project.."
    
        composer create-project --prefer-dist yiisoft/yii2-app-basic "$SITE_DIR/$DOMAIN/public_html/"
    fi
    
    #restart apache
    qdbus $PROGRESS Set "" value 5
    qdbus $PROGRESS setLabelText "Restart Apache.."
    
    kdesudo "service apache2 restart"
    
    qdbus $PROGRESS close
    
    kdialog --msgbox "Project succefully created!"
fi
