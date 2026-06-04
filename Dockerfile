FROM ghcr.io/okteto/okteto:3.20.0
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
