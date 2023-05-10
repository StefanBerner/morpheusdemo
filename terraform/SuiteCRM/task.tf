resource "morpheus_shell_script_task" "suitecrmappmn" {
  name                = "suitecrm install app multi node"
  code                = "suitecrminstallappMN"
  source_type         = "local"
  script_content = <<EOFF
RPass="<%=cypher.read('secret/mysql_root')%>"
CIPass="<%=cypher.read('secret/cloudinit')%>"
SCRMDb="<%=customOptions.databaseNameSCRM%>"
SCRMUser="<%=customOptions.databaseUserSCRM%>"
SCRMPass="<%=customOptions.databasePassSCRM%>"
MYSQL_HOST="<%=evars.SUITECRMDBMN_IP%>"
IP="<%=server.internalIp%>"
#Wait until any apt-get processes have finished
if [ `ps -ef | grep [a]pt-get | wc -l` = !0 ]
then
        sleep 120
fi
#Install sshpass and apache, start service and enable on boot
apt-get install sshpass -y
apt-get install apache2 -y
systemctl stop apache2.service
systemctl start apache2.service
systemctl enable apache2.service
#Use sshpass to remotely execute mysql commands on DB server to create database and database user
sshpass -p $CIPass ssh -o StrictHostKeyChecking=no -t cloudinit@$MYSQL_HOST <<REMOTE
sudo -S <<< "$CIPass" mysql -u root -p$RPass -e "CREATE USER '$SCRMUser'@'$IP' IDENTIFIED BY '$SCRMPass';"
sudo -S <<< "$CIPass" mysql -u root -p$RPass -e "CREATE DATABASE $SCRMDb;"
sudo -S <<< "$CIPass" mysql -u root -p$RPass -e "GRANT ALL ON $SCRMDb.* TO $SCRMUser@'$IP' IDENTIFIED BY '$SCRMPass';"
sudo -S <<< "$CIPass" mysql -u root -p$RPass -e "FLUSH PRIVILEGES;"
REMOTE
#Install required software for SuiteCRM
add-apt-repository ppa:ondrej/php -y
apt-get update
apt-get install php7.3 libapache2-mod-php7.3 php7.3-common php7.3-mysql php7.3-gmp php7.3-curl php7.3-intl php7.3-mbstring php7.3-xmlrpc php7.3-gd php7.3-bcmath php7.3-imap php7.3-xml php7.3-cli php7.3-zip -y
#Update php.ini file with required settings
short_open_tag=On
memory_limit=256M
upload_max_filesize=100M
max_execution_time=360
for key in short_open_tag memory_limit upload_max_filesize max_execution_time
do
 sed -i "s/^\($key\).*/\1 $(eval echo = \$${$key})/" /etc/php/7.3/apache2/php.ini
done
#Restart apache
systemctl restart apache2.service
#Test file created for debugging
echo "<?php phpinfo( ); ?>" | sudo tee /var/www/html/phpinfo.php
#Download and install latest SuiteCRM. Composer v2 does not work with Suitecrm.
curl -sS https://getcomposer.org/installer | sudo php -- --version=1.10.9 --install-dir=/usr/local/bin --filename=composer
git clone https://github.com/salesagility/SuiteCRM.git /var/www/html/suitecrm
cd /var/www/html/suitecrm
composer install --no-dev
chown -R www-data:www-data /var/www/html/suitecrm/
chmod -R 755 /var/www/html/suitecrm/
cat <<EOF | sudo tee /etc/apache2/sites-available/suitecrm.conf
VirtualHost *:80>

     ServerAdmin admin@localhost

     ServerAlias "<%=server.externalIp%>"

     DocumentRoot /var/www/html/suitecrm



     <Directory /var/www/html/suitecrm/>

          Options FollowSymlinks

          AllowOverride All

          Require all granted

     </Directory>



     ErrorLog $${APACHE_LOG_DIR}/error.log

     CustomLog $${APACHE_LOG_DIR}/access.log combined



     <Directory /var/www/html/suitecrm/>

            RewriteEngine on

            RewriteBase /

            RewriteCond %%{REQUEST_FILENAME} !-f

            RewriteRule ^(.*) index.php [PT,L]

    </Directory>

</VirtualHost>
EOF

EOFF
  sudo                = true
  retryable           = true
  retry_count         = 1
  retry_delay_seconds = 10
  allow_custom_config = true
}
resource "morpheus_shell_script_task" "suitecrmdbmn" {
  name                = "suitecrm install db multi node"
  code                = "suitecrminstalldbMN"
  source_type         = "local"
 script_content      = <<EOF
RPass="<%=cypher.read('secret/mysql_root')%>" 
IP="<%=server.internalIp%>" 
#Wait until any apt-get processes have finished 
if [ `ps -ef | grep [a]pt-get | wc -l` != 0 ] 
then 
        sleep 120 
fi 
#Install MariaDB, start service and enable on boot 
wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup 
echo "fd3f41eefff54ce144c932100f9e0f9b1d181e0edd86a6f6b8f2a0212100c32c mariadb_repo_setup" | sha256sum -c - 
chmod +x mariadb_repo_setup 
./mariadb_repo_setup  --mariadb-server-version="mariadb-10.6" 
apt update 
apt-get install mariadb-server mariadb-client -y 
systemctl stop mariadb.service 
systemctl start mariadb.service 
systemctl enable mariadb.service 
#The following commands are from the mysql secure installation guidance 
mysql -u root -e "UPDATE mysql.user SET Password=PASSWORD('$RPass') WHERE User='root';" 
mysql -u root -e "flush privileges" 
mysql -u root -p$RPass -e "DELETE FROM mysql.user WHERE User='';" 
mysql -u root -p$RPass -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" 
mysql -u root -p$RPass -e "DROP DATABASE IF EXISTS test;" 
mysql -u root -p$RPass -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';" 
mysql -u root -p$RPass -e "FLUSH PRIVILEGES;" 
#Set bind-address parameter in my.cnf 
sed -e '/^bind/s/^/#/g' -i /etc/mysql/mariadb.conf.d/50-server.cnf 
systemctl restart mariadb.service 
EOF  
  sudo                = true
  retryable           = true
  retry_count         = 1
  retry_delay_seconds = 10
  allow_custom_config = true
}
resource "morpheus_shell_script_task" "suitecrmapacherestart" {
  name                = "suitecrm apache restart"
  code                = "suitecrmapacherestart"
  source_type         = "local"
  script_content = <<EOF
a2ensite suitecrm.conf
a2enmod rewrite
systemctl restart apache2.service
EOF
  sudo                = true
  retryable           = true
  retry_count         = 1
  retry_delay_seconds = 10
  allow_custom_config = true
} 


