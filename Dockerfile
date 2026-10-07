FROM ghcr.io/okteto/okteto:master
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
