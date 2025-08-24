
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

# mkdir -p /var/www/localhost/htdocs/admin
mkdir -p /usr/share/nginx/html/admin
cp /config/html/index.html /usr/share/nginx/html/index.html
cp /config/html/admin/index.html /usr/share/nginx/html/admin/index.html



chown -R nginx:nginx /usr/share/nginx/html
chmod -R 755 /usr/share/nginx/html


# cp /config/html/index.html /usr/share/nginx/html/index.html

mkdir -p /etc/nginx/conf.d
cp /config/nginx.conf /etc/nginx/nginx.conf
cp /config/default.conf /etc/nginx/http.d/default.conf

mkdir -p /etc/nginx/conf.d

nginx -s reload





