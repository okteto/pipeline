FROM ramiro/okteto:1.8.19-rc1 as cli
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"] 