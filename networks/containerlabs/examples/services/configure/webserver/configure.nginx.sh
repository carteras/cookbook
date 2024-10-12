
apk add nginx openrc rsyslog

mkdir -p /run/openrc 
touch /run/openrc/softlevel 

# Ensure OpenRC directories exist
mkdir -p /run/openrc
touch /run/openrc/softlevel

# Start and enable rsyslog
rc-service rsyslog start
rc-update add rsyslog


rc-status -a

# Enable nginx to start on boot
rc-update add nginx

# Start nginx
rc-service nginx start

# Verify nginx status
rc-status -a

echo "nginx is running and available on port 80"

mkdir -p /var/www/localhost/htdocs
cp /config/html/index.html /var/www/localhost/htdocs/index.html
cp /configs/html/admin.html /var/www/localhost/htdocs/admin.html
cp /configs/nginx.cfg /etc/nginx/conf.d/default.conf




