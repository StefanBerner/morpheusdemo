resource "morpheus_file_template" "suitecrm-conf" {
  name             = "suitecrm-conf"
  file_name        = "suitecrm.conf"
  file_path        = "/etc/apache2/sites-available"
  phase            = "provision"
  file_content     = <<EOF
<VirtualHost *:80>

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
  file_owner       = "root"
  setting_name     = "suitecrm"
  setting_category = "App"
}
