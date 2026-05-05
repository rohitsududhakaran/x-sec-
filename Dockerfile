FROM python:3.11-slim

WORKDIR /app

COPY . .

RUN apt-get update && apt-get install -y \
    jq bc iptables procps systemd \
    && pip install requests

RUN chmod +x scripts/*.sh

CMD ["bash", "scripts/main.sh"]
