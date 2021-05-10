FROM okteto/okteto:1.12.10 as cli
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
