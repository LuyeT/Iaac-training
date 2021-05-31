echo "---!!!---Configuration---!!!---"

echo "--- Initial configuration setup ---"
dnf clean all
dnf -y update
dnf -y install firewalld

echo "--- configuration: PHP with PHP-FPM ---"
echo "--- installing apache and mod_ssl---"
dnf -y install httpd httpd-tools mod_ssl git

echo "--- installing remirepo and EPEL---"
dnf -y install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

echo "--- installing php resources ---"
dnf -y install php{,-common,-fpm,-gd,-json,-mbstring,-mysqlnd,-opcache,-pdo,-xml} mariadb{,-server} pwgen
dnf -y install python3-mysql

echo "--- downloading and installing configuration for php-fpm and apache-proxy ---"

cat ./www.conf > /etc/php-fpm.d/www.conf

cat ./example.com.conf > /etc/httpd/conf.d/example.com.conf
