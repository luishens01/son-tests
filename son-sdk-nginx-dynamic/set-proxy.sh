sed -i "s/IPPROXY/$PROXY_PASS/" /etc/nginx/conf.d/default.conf
nginx -g "daemon off;"
