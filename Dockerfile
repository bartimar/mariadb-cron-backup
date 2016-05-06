FROM mariadb:latest

# Create fake chown so docker scripts won't fail (ugly)
RUN mv /bin/chown /bin/chown.disabled
COPY chown /bin/chown

# cron backup
RUN apt-get update && apt-get install -y cron && rm -rf /var/lib/apt/lists/*

# backup entrypoint
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["cron","-f"]
