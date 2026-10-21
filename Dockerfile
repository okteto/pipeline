FROM ghcr.io/okteto/okteto:3.24.1
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
