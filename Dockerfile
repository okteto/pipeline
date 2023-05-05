FROM okteto/okteto:2.15.3-beta.1
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
