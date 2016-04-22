FROM nginx
MAINTAINER Felipe Vicens
COPY default.conf /etc/nginx/conf.d/default.conf
COPY set-proxy.sh /etc/nginx/conf.d/set-proxy.sh
RUN chmod +x /etc/nginx/conf.d/set-proxy.sh
CMD ["bash", "/etc/nginx/conf.d/set-proxy.sh"]
