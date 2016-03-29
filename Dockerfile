FROM haproxy:1.6

EXPOSE 80

ADD run.sh .
ADD haproxy.cfg.sh .
CMD ["./run.sh"]
