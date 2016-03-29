FROM galexrt/pen

EXPOSE 80
EXPOSE 9000

ENTRYPOINT []

COPY run.sh .
CMD ["./run.sh"]
