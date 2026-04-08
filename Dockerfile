FROM ghcr.io/okteto/okteto:3.18.0
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
