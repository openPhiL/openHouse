##########################################################################################
#!/bin/bash
# (c) Carsten Rieger IT-Services (Ubuntu 20.04+ LTS 64BIT)
# Nextcloud 19+
# Version 200627: 
# nextcloud.conf: "location ~ ^\/(?:build|tests|config|lib|3rdparty|templates|data)\/ {"
##########################################################################################

# Donatations are really appreciated
# => https://paypal.me/carstenrieger
##########################################################################################

###global function to update and cleanup the environment
function update_and_clean() {
apt update
apt upgrade -y
apt autoclean -y
apt autoremove -y
}
###global function to restart all cloud services
function restart_all_services() {
/usr/sbin/service nginx restart
/usr/sbin/service mysql restart
/usr/sbin/service redis-server restart
/usr/sbin/service php7.4-fpm restart
}
###global function to scan Nextcloud data and generate an overview for fail2ban & ufw
function nextcloud_scan_data() {
sudo -u www-data php /var/www/nextcloud/occ files:scan --all
sudo -u www-data php /var/www/nextcloud/occ files:scan-app-data
fail2ban-client status nextcloud
ufw status verbose
}
### START ###
rm -f /etc/resolv.conf
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
systemctl restart systemd-resolved.service
apt install gnupg gnupg2 lsb-release wget curl -y
###prepare the server environment
cd /etc/apt/sources.list.d
echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu $(lsb_release -cs) main" | tee php.list
echo "deb http://nginx.org/packages/mainline/ubuntu $(lsb_release -cs) nginx" | tee nginx.list
echo "deb http://ftp.hosteurope.de/mirror/mariadb.org/repo/10.4/ubuntu $(lsb_release -cs) main" | tee mariadb.list
###
curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
apt-key adv --recv-keys --keyserver hkps://keyserver.ubuntu.com:443 4F4EA0AAE5267A6C
apt-key adv --recv-keys --keyserver hkps://keyserver.ubuntu.com:443 0xF1656F24C74CD1D8
update_and_clean
apt install software-properties-common zip unzip screen git wget ffmpeg libfile-fcntllock-perl locate ghostscript tree htop -y
apt remove nginx nginx-common nginx-full -y --allow-change-held-packages
###instal NGINX using TLSv1.3, OpenSSL 1.1.1
update_and_clean
apt install nginx -y
###enable NGINX autostart
systemctl enable nginx.service
### prepare the NGINX
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak && touch /etc/nginx/nginx.conf
cat <<EOF >/etc/nginx/nginx.conf
user www-data;
worker_processes auto;
pid /var/run/nginx.pid;
events {
worker_connections 1024;
multi_accept on;
use epoll;
}
http {
server_names_hash_bucket_size 64;
upstream php-handler {
server unix:/run/php/php7.4-fpm.sock;
}
set_real_ip_from 127.0.0.1;
# set_real_ip_from 192.168.2.0/24;
real_ip_header X-Forwarded-For;
real_ip_recursive on;
include /etc/nginx/mime.types;
#include /etc/nginx/proxy.conf;
#include /etc/nginx/ssl.conf;
#include /etc/nginx/header.conf;
#include /etc/nginx/optimization.conf;
default_type application/octet-stream;
access_log /var/log/nginx/access.log;
error_log /var/log/nginx/error.log warn;
sendfile on;
send_timeout 3600;
tcp_nopush on;
tcp_nodelay on;
open_file_cache max=500 inactive=10m;
open_file_cache_errors on;
keepalive_timeout 65;
reset_timedout_connection on;
server_tokens off;
resolver 127.0.0.53 valid=30s;
resolver_timeout 5s;
include /etc/nginx/conf.d/*.conf;
}
EOF
###restart NGINX
/usr/sbin/service nginx restart
###create folders
mkdir -p /var/www/letsencrypt /etc/letsencrypt/rsa-certs /etc/letsencrypt/ecc-certs
###apply permissions
chown -R www-data:www-data /var/www
###install PHP - Backup default files
apt install php7.4-fpm php7.4-gd php7.4-mysql php7.4-curl php7.4-xml php7.4-zip php7.4-intl php7.4-mbstring php7.4-json php7.4-bz2 php7.4-ldap php-apcu php7.4-bcmath php7.4-gmp imagemagick php-imagick php-smbclient -y
cp /etc/php/7.4/fpm/pool.d/www.conf /etc/php/7.4/fpm/pool.d/www.conf.bak
cp /etc/php/7.4/cli/php.ini /etc/php/7.4/cli/php.ini.bak
cp /etc/php/7.4/fpm/php.ini /etc/php/7.4/fpm/php.ini.bak
cp /etc/php/7.4/fpm/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf.bak
cp /etc/ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xml.bak
###PHP Mods: www.conf
sed -i "s/;env\[HOSTNAME\] = /env[HOSTNAME] = /" /etc/php/7.4/fpm/pool.d/www.conf
sed -i "s/;env\[TMP\] = /env[TMP] = /" /etc/php/7.4/fpm/pool.d/www.conf
sed -i "s/;env\[TMPDIR\] = /env[TMPDIR] = /" /etc/php/7.4/fpm/pool.d/www.conf
sed -i "s/;env\[TEMP\] = /env[TEMP] = /" /etc/php/7.4/fpm/pool.d/www.conf
sed -i "s/;env\[PATH\] = /env[PATH] = /" /etc/php/7.4/fpm/pool.d/www.conf
sed -i "s/pm.max_children =.*/pm.max_children = 120/" /etc/php/7.4/fpm/pool.d/www.conf
sed -i "s/pm.start_servers =.*/pm.start_servers = 12/" /etc/php/7.4/fpm/pool.d/www.conf
sed -i "s/pm.min_spare_servers =.*/pm.min_spare_servers = 6/" /etc/php/7.4/fpm/pool.d/www.conf
sed -i "s/pm.max_spare_servers =.*/pm.max_spare_servers = 18/" /etc/php/7.4/fpm/pool.d/www.conf
sed -i "s/;pm.max_requests =.*/pm.max_requests = 1000/" /etc/php/7.4/fpm/pool.d/www.conf
###PHP Mods: cli/php.ini
sed -i "s/output_buffering =.*/output_buffering = 'Off'/" /etc/php/7.4/cli/php.ini
sed -i "s/max_execution_time =.*/max_execution_time = 3600/" /etc/php/7.4/cli/php.ini
sed -i "s/max_input_time =.*/max_input_time = 3600/" /etc/php/7.4/cli/php.ini
sed -i "s/post_max_size =.*/post_max_size = 10240M/" /etc/php/7.4/cli/php.ini
sed -i "s/upload_max_filesize =.*/upload_max_filesize = 10240M/" /etc/php/7.4/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = Europe\/\Berlin/" /etc/php/7.4/cli/php.ini
###PHP Mods: fpm/php.ini
sed -i "s/memory_limit = 128M/memory_limit = 1024M/" /etc/php/7.4/fpm/php.ini
sed -i "s/output_buffering =.*/output_buffering = 'Off'/" /etc/php/7.4/fpm/php.ini
sed -i "s/max_execution_time =.*/max_execution_time = 3600/" /etc/php/7.4/fpm/php.ini
sed -i "s/max_input_time =.*/max_input_time = 3600/" /etc/php/7.4/fpm/php.ini
sed -i "s/post_max_size =.*/post_max_size = 10240M/" /etc/php/7.4/fpm/php.ini
sed -i "s/upload_max_filesize =.*/upload_max_filesize = 10240M/" /etc/php/7.4/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = Europe\/\Berlin/" /etc/php/7.4/fpm/php.ini
sed -i "s/;session.cookie_secure.*/session.cookie_secure = True/" /etc/php/7.4/fpm/php.ini
sed -i "s/;opcache.enable=.*/opcache.enable=1/" /etc/php/7.4/fpm/php.ini
sed -i "s/;opcache.enable_cli=.*/opcache.enable_cli=1/" /etc/php/7.4/fpm/php.ini
sed -i "s/;opcache.memory_consumption=.*/opcache.memory_consumption=128/" /etc/php/7.4/fpm/php.ini
sed -i "s/;opcache.interned_strings_buffer=.*/opcache.interned_strings_buffer=8/" /etc/php/7.4/fpm/php.ini
sed -i "s/;opcache.max_accelerated_files=.*/opcache.max_accelerated_files=10000/" /etc/php/7.4/fpm/php.ini
sed -i "s/;opcache.revalidate_freq=.*/opcache.revalidate_freq=1/" /etc/php/7.4/fpm/php.ini
sed -i "s/;opcache.save_comments=.*/opcache.save_comments=1/" /etc/php/7.4/fpm/php.ini
sed -i "$aapc.enable_cli=1" /etc/php/7.4/mods-available/apcu.ini
### Solution for ImageMagick errors
sed -i "s/rights=\"none\" pattern=\"PS\"/rights=\"read|write\" pattern=\"PS\"/" /etc/ImageMagick-6/policy.xml
sed -i "s/rights=\"none\" pattern=\"EPS\"/rights=\"read|write\" pattern=\"EPS\"/" /etc/ImageMagick-6/policy.xml
sed -i "s/rights=\"none\" pattern=\"PDF\"/rights=\"read|write\" pattern=\"PDF\"/" /etc/ImageMagick-6/policy.xml
sed -i "s/rights=\"none\" pattern=\"XPS\"/rights=\"read|write\" pattern=\"XPS\"/" /etc/ImageMagick-6/policy.xml
ln -s /usr/local/bin/gs /usr/bin/gs
###restart PHP and NGINX
/usr/sbin/service php7.4-fpm restart
/usr/sbin/service nginx restart
###install MariaDB
apt update && apt install mariadb-server -y
/usr/sbin/service mysql stop
###configure MariaDB
mv /etc/mysql/my.cnf /etc/mysql/my.cnf.bak
cat <<EOF >/etc/mysql/my.cnf
[client]
default-character-set = utf8mb4
port = 3306
socket = /var/run/mysqld/mysqld.sock
[mysqld_safe]
log_error=/var/log/mysql/mysql_error.log
nice = 0
socket = /var/run/mysqld/mysqld.sock
[mysqld]
basedir = /usr
bind-address = 127.0.0.1
binlog_format = ROW
bulk_insert_buffer_size = 16M
character-set-server = utf8mb4
collation-server = utf8mb4_general_ci
concurrent_insert = 2
connect_timeout = 5
datadir = /var/lib/mysql
default_storage_engine = InnoDB
expire_logs_days = 2
general_log_file = /var/log/mysql/mysql.log
general_log = 0
innodb_buffer_pool_size = 1024M
innodb_buffer_pool_instances = 1
innodb_flush_log_at_trx_commit = 2
innodb_log_buffer_size = 32M
innodb_max_dirty_pages_pct = 90
innodb_file_per_table = 1
innodb_open_files = 400
innodb_io_capacity = 4000
innodb_flush_method = O_DIRECT
key_buffer_size = 128M
lc_messages_dir = /usr/share/mysql
lc_messages = en_US
log_bin = /var/log/mysql/mariadb-bin
log_bin_index = /var/log/mysql/mariadb-bin.index
log_error = /var/log/mysql/mysql_error.log
log_slow_verbosity = query_plan
log_warnings = 2
long_query_time = 1
max_allowed_packet = 16M
max_binlog_size = 100M
max_connections = 200
max_heap_table_size = 64M
myisam_recover_options = BACKUP
myisam_sort_buffer_size = 512M
port = 3306
pid-file = /var/run/mysqld/mysqld.pid
query_cache_limit = 2M
query_cache_size = 64M
query_cache_type = 1
query_cache_min_res_unit = 2k
read_buffer_size = 2M
read_rnd_buffer_size = 1M
skip-external-locking
skip-name-resolve
slow_query_log_file = /var/log/mysql/mariadb-slow.log
slow-query-log = 1
socket = /var/run/mysqld/mysqld.sock
sort_buffer_size = 4M
table_open_cache = 400
thread_cache_size = 128
tmp_table_size = 64M
tmpdir = /tmp
transaction_isolation = READ-COMMITTED
#unix_socket=OFF
user = mysql
wait_timeout = 600
[mysqldump]
max_allowed_packet = 16M
quick
quote-names
[isamchk]
key_buffer = 16M
EOF
/usr/sbin/service mysql restart
###restart MariaDB server and connect to MariaDB to create the database
/usr/sbin/service mysql restart && mysql -uroot <<EOF
CREATE DATABASE nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER nextcloud@localhost identified by 'nextcloud';
GRANT ALL PRIVILEGES on nextcloud.* to nextcloud@localhost;
FLUSH privileges;
EOF
clear
echo ""
echo " Your database server will now be hardened - just follow the instructions."
echo " Keep in mind: your MariaDB root password is still NOT set!"
echo ""
###harden your MariDB server
mysql_secure_installation
update_and_clean
###install Redis-Server
apt install redis-server php-redis -y
cp /etc/redis/redis.conf /etc/redis/redis.conf.bak
sed -i "s/port 6379/port 0/" /etc/redis/redis.conf
sed -i s/\#\ unixsocket/\unixsocket/g /etc/redis/redis.conf
sed -i "s/unixsocketperm 700/unixsocketperm 770/" /etc/redis/redis.conf
sed -i "s/# maxclients 10000/maxclients 512/" /etc/redis/redis.conf
usermod -a -G redis www-data
cp /etc/sysctl.conf /etc/sysctl.conf.bak && sed -i '$avm.overcommit_memory = 1' /etc/sysctl.conf
###install self signed certificates
apt install ssl-cert -y
###prepare NGINX for Nextcloud and SSL
[ -f /etc/nginx/conf.d/default.conf ] && mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
touch /etc/nginx/conf.d/default.conf
cat <<EOF >/etc/nginx/conf.d/nextcloud.conf
server {
server_name YOUR.DEDYN.IO;
listen 80 default_server;
listen [::]:80 default_server;
location ^~ /.well-known/acme-challenge {
proxy_pass http://127.0.0.1:81;
proxy_set_header Host \$host;
}
location / {
return 301 https://\$host\$request_uri;
}
}
server {
server_name YOUR.DEDYN.IO;
listen 443 ssl http2 default_server;
listen [::]:443 ssl http2 default_server;
root /var/www/nextcloud/;
location = /robots.txt {
allow all;
log_not_found off;
access_log off;
}
location = /.well-known/carddav {
return 301 \$scheme://\$host/remote.php/dav;
}
location = /.well-known/caldav {
return 301 \$scheme://\$host/remote.php/dav;
}
#SOCIAL app enabled? Please uncomment the following row
#rewrite ^/.well-known/webfinger /public.php?service=webfinger last;
#WEBFINGER app enabled? Please uncomment the following two rows.
#rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
#rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json last;
client_max_body_size 10240M;
location / {
rewrite ^ /index.php;
}
location ~ ^\/(?:build|tests|config|lib|3rdparty|templates|data)\/ {
deny all;
}
location ~ ^\/(?:\.|autotest|occ|issue|indie|db_|console) {
deny all;
}
location ^~ /apps/rainloop/app/data {
deny all;
}
location ~ \.(?:flv|mp4|mov|m4a|mp3|mkv)$ {
mp4;
mp4_buffer_size 100M;
mp4_max_buffer_size 1024M;
fastcgi_split_path_info ^(.+?.php)(\/.*|)\$;
set \$path_info \$fastcgi_path_info;
try_files \$fastcgi_script_name =404;
include fastcgi_params;
include php_optimization.conf;
}
location ~ ^\/(?:index|remote|public|cron|core\/ajax\/update|status|ocs\/v[12]|updater\/.+|oc[ms]-provider\/.+|.+\/richdocumentscode\/proxy)\.php(?:$|\/) {
fastcgi_split_path_info ^(.+?.php)(\/.*|)\$;
set \$path_info \$fastcgi_path_info;
try_files \$fastcgi_script_name =404;
include fastcgi_params;
include php_optimization.conf;
}
location ~ ^\/(?:updater|oc[ms]-provider)(?:\$|\/) {
try_files \$uri/ =404;
index index.php;
}
location ~ \.(?:css|js|woff2?|svg|gif|map|png|html|ttf|ico|jpg|jpeg|bcmap|webm)$ {
try_files \$uri /index.php\$request_uri;
access_log off;
expires 360d;
}
}
EOF
###create a Let's Encrypt vhost file
touch /etc/nginx/conf.d/letsencrypt.conf
cat <<EOF >/etc/nginx/conf.d/letsencrypt.conf
server
{
server_name 127.0.0.1;
listen 127.0.0.1:81 default_server;
charset utf-8;
location ^~ /.well-known/acme-challenge
{
default_type text/plain;
root /var/www/letsencrypt;
}
}
EOF
###create a ssl configuration file
touch /etc/nginx/ssl.conf
cat <<EOF >/etc/nginx/ssl.conf
ssl_certificate /etc/ssl/certs/ssl-cert-snakeoil.pem;
ssl_certificate_key /etc/ssl/private/ssl-cert-snakeoil.key;
ssl_trusted_certificate /etc/ssl/certs/ssl-cert-snakeoil.pem;
#ssl_certificate /etc/letsencrypt/rsa-certs/fullchain.pem;
#ssl_certificate_key /etc/letsencrypt/rsa-certs/privkey.pem;
#ssl_certificate /etc/letsencrypt/ecc-certs/fullchain.pem;
#ssl_certificate_key /etc/letsencrypt/ecc-certs/privkey.pem;
#ssl_trusted_certificate /etc/letsencrypt/ecc-certs/chain.pem;
ssl_dhparam /etc/ssl/certs/dhparam.pem;
ssl_session_timeout 1d; ssl_session_cache shared:SSL:50m;
ssl_session_tickets off; ssl_protocols TLSv1.3 TLSv1.2;
ssl_ciphers 'TLS-CHACHA20-POLY1305-SHA256:TLS-AES-256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384';
ssl_ecdh_curve X448:secp521r1:secp384r1:prime256v1;
ssl_prefer_server_ciphers on;
ssl_stapling on;
ssl_stapling_verify on;
EOF
###add a default dhparam.pem file // https://wiki.mozilla.org/Security/Server_Side_TLS#ffdhe4096
touch /etc/ssl/certs/dhparam.pem
cat <<EOF >/etc/ssl/certs/dhparam.pem
-----BEGIN DH PARAMETERS-----
MIICCAKCAgEA//////////+t+FRYortKmq/cViAnPTzx2LnFg84tNpWp4TZBFGQz
+8yTnc4kmz75fS/jY2MMddj2gbICrsRhetPfHtXV/WVhJDP1H18GbtCFY2VVPe0a
87VXE15/V8k1mE8McODmi3fipona8+/och3xWKE2rec1MKzKT0g6eXq8CrGCsyT7
YdEIqUuyyOP7uWrat2DX9GgdT0Kj3jlN9K5W7edjcrsZCwenyO4KbXCeAvzhzffi
7MA0BM0oNC9hkXL+nOmFg/+OTxIy7vKBg8P+OxtMb61zO7X8vC7CIAXFjvGDfRaD
ssbzSibBsu/6iGtCOGEfz9zeNVs7ZRkDW7w09N75nAI4YbRvydbmyQd62R0mkff3
7lmMsPrBhtkcrv4TCYUTknC0EwyTvEN5RPT9RFLi103TZPLiHnH1S/9croKrnJ32
nuhtK8UiNjoNq8Uhl5sN6todv5pC1cRITgq80Gv6U93vPBsg7j/VnXwl5B0rZp4e
8W5vUsMWTfT7eTDp5OWIV7asfV9C1p9tGHdjzx1VA0AEh/VbpX4xzHpxNciG77Qx
iu1qHgEtnmgyqQdgCpGBMMRtx3j5ca0AOAkpmaMzy4t6Gh25PXFAADwqTs6p+Y0K
zAqCkc3OyX3Pjsm1Wn+IpGtNtahR9EGC4caKAH5eZV9q//////////8CAQI=
-----END DH PARAMETERS-----
EOF
###create a proxy configuration file
touch /etc/nginx/proxy.conf
cat <<EOF >/etc/nginx/proxy.conf
proxy_set_header Host \$host;
proxy_set_header X-Real-IP \$remote_addr;
proxy_set_header X-Forwarded-Host \$host;
proxy_set_header X-Forwarded-Protocol \$scheme;
proxy_set_header X-Forwarded-For \$remote_addr;
proxy_set_header X-Forwarded-Port \$server_port;
proxy_set_header X-Forwarded-Server \$host;
proxy_connect_timeout 3600;
proxy_send_timeout 3600;
proxy_read_timeout 3600;
proxy_redirect off;
EOF
###create a header configuration file
touch /etc/nginx/header.conf
cat <<EOF >/etc/nginx/header.conf
add_header Strict-Transport-Security "max-age=15768000; includeSubDomains; preload;";
add_header X-Robots-Tag none always;
add_header X-Download-Options noopen always;
add_header X-Permitted-Cross-Domain-Policies none always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "no-referrer" always;
add_header X-Frame-Options "SAMEORIGIN" always;
EOF
###create a nginx optimization file
touch /etc/nginx/optimization.conf
cat <<EOF >/etc/nginx/optimization.conf
fastcgi_hide_header X-Powered-By;
fastcgi_read_timeout 3600;
fastcgi_send_timeout 3600;
fastcgi_connect_timeout 3600;
fastcgi_buffers 64 64K;
fastcgi_buffer_size 256k;
fastcgi_busy_buffers_size 3840K;
fastcgi_cache_key \$http_cookie\$request_method\$host\$request_uri;
fastcgi_cache_use_stale error timeout invalid_header http_500;
fastcgi_ignore_headers Cache-Control Expires Set-Cookie;
gzip on;
gzip_vary on;
gzip_comp_level 4;
gzip_min_length 256;
gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;
gzip_disable "MSIE [1-6]\.";
EOF
###create a nginx php optimization file
touch /etc/nginx/php_optimization.conf
cat <<EOF >/etc/nginx/php_optimization.conf
fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
fastcgi_param PATH_INFO \$path_info;
fastcgi_param modHeadersAvailable true;
fastcgi_param front_controller_active true;
fastcgi_pass php-handler;
fastcgi_param HTTPS on;
fastcgi_intercept_errors on;
fastcgi_request_buffering off;
fastcgi_cache_valid 404 1m;
fastcgi_cache_valid any 1h;
fastcgi_cache_methods GET HEAD;
EOF
###enable all nginx configuration files
sed -i s/\#\include/\include/g /etc/nginx/nginx.conf
sed -i "s/server_name YOUR.DEDYN.IO;/server_name $(hostname);/" /etc/nginx/conf.d/nextcloud.conf
###create Nextclouds cronjob
(crontab -u www-data -l ; echo "*/5 * * * * php -f /var/www/nextcloud/cron.php > /dev/null 2>&1") | crontab -u www-data -
###restart NGINX
/usr/sbin/service nginx restart
###Download Nextclouds latest release and extract it
wget https://download.nextcloud.com/server/releases/latest.tar.bz2
tar -xjf latest.tar.bz2 -C /var/www
###apply permissions
chown -R www-data:www-data /var/www/
###remove the Nextcloud sources
rm -f latest.tar.bz2
###update and restart all sources and services
update_and_clean
restart_all_services
clear
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Nextcloud-Administrator and password - Attention: password is case-sensitive:"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""
echo "Your Nextcloud-DB user: nextcloud"
echo ""
echo "Your Nextcloud-DB password: nextcloud"
echo ""
read -p "Enter your Nextcloud Administrator: " NEXTCLOUDADMINUSER
echo "Your Nextcloud Administrator: "$NEXTCLOUDADMINUSER
echo ""
read -p "Enter your Nextcloud Administrator password: " NEXTCLOUDADMINUSERPASSWORD
echo "Your Nextcloud Administrator password: "$NEXTCLOUDADMINUSERPASSWORD
echo ""
while [[ $NEXTCLOUDDATAPATH == '' ]]
do
read -p "Enter your absolute Nextcloud datapath (/your/path): " NEXTCLOUDDATAPATH
if [[ -z "$NEXTCLOUDDATAPATH" ]]; then
echo "datapath must not be empty!"
echo""
else
echo "Your Nextcloud datapath: "$NEXTCLOUDDATAPATH
fi
done
if [[ ! -e $NEXTCLOUDDATAPATH ]];
then
  mkdir -p $NEXTCLOUDDATAPATH
fi
chown -R www-data:www-data $NEXTCLOUDDATAPATH
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""
echo "Your NEXTCLOUD will now be installed silently - please be patient ..."
echo ""
###NEXTCLOUD INSTALLATION
sudo -u www-data php /var/www/nextcloud/occ maintenance:install --database "mysql" --database-name nextcloud --database-user nextcloud --database-pass nextcloud --admin-user "$NEXTCLOUDADMINUSER" --admin-pass "$NEXTCLOUDADMINUSERPASSWORD" --data-dir "$NEXTCLOUDDATAPATH"
###read and store the current hostname in lowercases
declare -l YOURSERVERNAME
YOURSERVERNAME=$(hostname)
###Modifications to Nextclouds config.php
sudo -u www-data cp /var/www/nextcloud/config/config.php /var/www/nextcloud/config/config.php.bak
sudo -u www-data php /var/www/nextcloud/occ config:system:set trusted_domains 0 --value=$YOURSERVERNAME
sudo -u www-data php /var/www/nextcloud/occ config:system:set overwrite.cli.url --value=https://$YOURSERVERNAME
echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
###backup of the effected file .user.ini
cp /var/www/nextcloud/.user.ini /usr/local/src/.user.ini.bak
###apply Nextcloud optimizations
sudo -u www-data sed -i "s/output_buffering=.*/output_buffering='Off'/" /var/www/nextcloud/.user.ini
sudo -u www-data php /var/www/nextcloud/occ background:cron
###apply optimizations to Nextclouds global config.php
sed -i '/);/d' /var/www/nextcloud/config/config.php
cat <<EOF >>/var/www/nextcloud/config/config.php
'activity_expire_days' => 14,
'auth.bruteforce.protection.enabled' => true,
'blacklisted_files' =>
array (
0 => '.htaccess',
1 => 'Thumbs.db',
2 => 'thumbs.db',
),
'cron_log' => true,
'enable_previews' => true,
'enabledPreviewProviders' =>
array (
0 => 'OC\\Preview\\PNG',
1 => 'OC\\Preview\\JPEG',
2 => 'OC\\Preview\\GIF',
3 => 'OC\\Preview\\BMP',
4 => 'OC\\Preview\\XBitmap',
5 => 'OC\\Preview\\Movie',
6 => 'OC\\Preview\\PDF',
7 => 'OC\\Preview\\MP3',
8 => 'OC\\Preview\\TXT',
9 => 'OC\\Preview\\MarkDown',
),
'filesystem_check_changes' => 0,
'filelocking.enabled' => 'true',
'htaccess.RewriteBase' => '/',
'integrity.check.disabled' => false,
'knowledgebaseenabled' => false,
'log_rotate_size' => 104857600,
'logfile' => '$NEXTCLOUDDATAPATH/nextcloud.log',
'logtimezone' => 'Europe/Berlin',
'memcache.local' => '\\OC\\Memcache\\APCu',
'memcache.locking' => '\\OC\\Memcache\\Redis',
'preview_max_x' => 1024,
'preview_max_y' => 768,
'preview_max_scale_factor' => 1,
'redis' =>
array (
'host' => '/var/run/redis/redis-server.sock',
'port' => 0,
'timeout' => 0.0,
),
'quota_include_external_storage' => false,
'share_folder' => '/Shares',
'skeletondirectory' => '',
'trashbin_retention_obligation' => 'auto, 7',
);
EOF
sed -i "s/.*dbhost.*/\ \ 'dbhost\' \=\>\ \'localhost\:\/var\/run\/mysqld\/mysqld\.sock\'\,/g" /var/www/nextcloud/config/config.php
###remove leading whitespaces
sed -i 's/^[ ]*//' /var/www/nextcloud/config/config.php
chown -R www-data:www-data /var/www
restart_all_services
update_and_clean
###install fail2ban
apt install fail2ban -y
###create a fail2ban Nextcloud filter
touch /etc/fail2ban/filter.d/nextcloud.conf
cat <<EOF >/etc/fail2ban/filter.d/nextcloud.conf
[Definition]
failregex=^{"reqId":".*","remoteAddr":".*","app":"core","message":"Login failed: '.*' \(Remote IP: '<HOST>'\)","level":2,"time":".*"}$
          ^{"reqId":".*","level":2,"time":".*","remoteAddr":".*","user,:".*","app":"no app in context".*","method":".*","message":"Login failed: '.*' \(Remote IP: '<HOST>'\)".*}$
          ^{"reqId":".*","level":2,"time":".*","remoteAddr":".*","user":".*","app":".*","method":".*","url":".*","message":"Login failed: .* \(Remote IP: <HOST>\).*}$
EOF
###create a fail2ban Nextcloud jail
touch /etc/fail2ban/jail.d/nextcloud.local
cat <<EOF >/etc/fail2ban/jail.d/nextcloud.local
[nextcloud]
backend = auto
enabled = true
port = 80,443
protocol = tcp
filter = nextcloud
maxretry = 5
bantime = 3600
findtime = 3600
logpath = $NEXTCLOUDDATAPATH/nextcloud.log
[nginx-http-auth]
enabled = true
EOF
update_and_clean
###install ufw
apt install ufw -y
###open firewall ports 80+443 for http(s)
ufw allow 80/tcp
ufw allow 443/tcp
###open firewall port 22 for SSH
ufw allow 22/tcp
###enable UFW (autostart)
ufw logging medium && ufw default deny incoming && ufw enable
###restart fail2ban, ufw and redis-server services
/usr/sbin/service ufw restart
/usr/sbin/service fail2ban restart
/usr/sbin/service redis-server restart
sudo -u www-data php /var/www/nextcloud/occ app:disable survey_client
sudo -u www-data php /var/www/nextcloud/occ app:disable firstrunwizard
sudo -u www-data php /var/www/nextcloud/occ app:enable admin_audit
sudo -u www-data php /var/www/nextcloud/occ app:enable files_pdfviewer
###clean up redis-server
redis-cli -s /var/run/redis/redis-server.sock <<EOF
FLUSHALL
quit
EOF
###Nextcloud occ db:... (maintenance/optimization)
/usr/sbin/service nginx stop
clear
echo "---------------------------------"
echo "Issue Nextcloud-DB optimizations!"
echo "---------------------------------"
echo "Press 'y' to issue optimizations."
echo "---------------------------------"
echo ""
sudo -u www-data php /var/www/nextcloud/occ db:add-missing-indices
sudo -u www-data php /var/www/nextcloud/occ db:add-missing-columns
sudo -u www-data php /var/www/nextcloud/occ db:convert-filecache-bigint
sudo -u www-data php /var/www/nextcloud/occ security:certificates:import /etc/ssl/certs/ssl-cert-snakeoil.pem
###rescan Nextcloud data
nextcloud_scan_data
restart_all_services
### issue the cron.php once
sudo -u www-data php /var/www/nextcloud/cron.php
clear
echo ""
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""
echo " Open your browser and call your Nextcloud at"
echo ""
echo " https://$YOURSERVERNAME"
echo ""
echo "*******************************************************************************"
echo "Your Nextcloud DB data : nextcloud | nextcloud"
echo ""
echo "Your Nextcloud User    : "$NEXTCLOUDADMINUSER
echo "Your Nextcloud Password: "$NEXTCLOUDADMINUSERPASSWORD
echo "Your Nextcloud datapath: "$NEXTCLOUDDATAPATH
echo ""
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""
echo " I do strongly recommend to enhance the server security by re-creating"
echo " the dhparam.pem file:"
echo ""
echo " openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096"
echo ""
echo " https://www.c-rieger.de/nextcloud-installationsanleitung/#dhparamfile"
echo ""
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""
### CleanUp
cat /dev/null > ~/.bash_history && history -c && history -w
exit 0