FROM ghcr.io/okteto/okteto:3.17.1
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
