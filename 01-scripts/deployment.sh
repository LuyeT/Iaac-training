#for lack of a vault service, db credentials will be generated and stored in these 2 files
sqlrootpath="/var/www/sqlroot.ini"
sqlcentospath="/var/www/sqlcentos.ini"

echo "---!!!--- configuring firewall ---!!!---"

sudo systemctl start firewalld
sudo systemctl enable firewalld

sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https

sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --permanent --add-port=10000/tcp

sudo firewall-cmd --reload

sudo systemctl start mariadb
sudo systemctl enable mariadb

echo "---!!!--- setting up DB credentials ---!!!---"
# create DB credentials if not present
if [ ! -f "$sqlrootpath" ]; then
  placeholder="$(pwgen 28 1 )"
  sudo sh mariadb-secure-installation.sh "$placeholder"
  echo "[client]
  user=root
  password=$placeholder" | sudo tee -a "$sqlrootpath"
fi

if [ ! -f "$sqlcentospath" ]; then
  placeholder="$(pwgen 28 1 )"
  echo "[client]
  user=centos
  password=$placeholder" | sudo tee -a "$sqlcentospath"
fi
sudo chmod 600 $sqlrootpath
sudo chmod 600 $sqlcentospath
sudo chown apache:apache $sqlcentospath

echo "---!!!--- setting up DB ---!!!---"
# construct database tables and create an admin user for the Fantasy_Taverns web app
git clone https://github.com/LuyeT/Fantasy_Taverns-mysql
cd /home/centos/Fantasy_Taverns-mysql
sudo mysql --defaults-extra-file=$sqlrootpath < ./master.sql
sudo mysql --defaults-extra-file=$sqlrootpath -e "CREATE USER 'centos'@'localhost' IDENTIFIED BY 'password'; GRANT ALL PRIVILEGES ON Fantasy_Taverns.* TO 'centos'@'localhost';"

if [[ "$placeholder" != "" ]]; then
  sudo mysql --defaults-extra-file=$sqlrootpath << _EOF_
    set password for 'centos'@'localhost' = password('${placeholder}');
_EOF_
fi

echo "---!!!--- setting up webapp ---!!!---"
cd /var/www/html
sudo git clone https://github.com/LuyeT/Fantasy_Taverns-php

sudo systemctl enable httpd
sudo systemctl start httpd

sudo systemctl enable php-fpm
sudo systemctl start php-fpm

# SElinux permanently grants access for apache connection to DB
#sudo setsebool -P httpd_can_network_connect 1
sudo setsebool -P httpd_can_network_connect_db 1
