echo "---!!!---Configuration---!!!---"

echo "--- Initial configuration setup ---"
sudo dnf clean all
sudo dnf -y update
sudo dnf -y install firewalld

echo "--- configuration: PHP with PHP-FPM ---"
echo "--- installing apache and mod_ssl---"
sudo dnf -y install httpd httpd-tools mod_ssl git

echo "--- installing remirepo and EPEL---"
sudo dnf -y install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

echo "--- installing php resources ---"
sudo dnf -y install php{,-common,-fpm,-gd,-json,-mbstring,-mysqlnd,-opcache,-pdo,-xml} mariadb{,-server} pwgen
sudo dnf -y install python3-mysql

echo "--- downloading and installing configuration for php-fpm and apache-proxy ---"

sudo cat ./www.conf > /etc/php-fpm.d/www.conf

sudo cat ./example.com.conf > /etc/httpd/conf.d/example.com.conf
