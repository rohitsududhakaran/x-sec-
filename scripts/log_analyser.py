import re
import json
from collections import defaultdict

auth_log = "/var/log/auth.log"
apache_log = "/var/log/apache2/access.log"
syslog = "/var/log/messages"
kern_log = "/var/log/kern.log"

suspicious_ips = set()
alerts = []

def detect_auth():
    failed = defaultdict(int)

    try:
        with open(auth_log) as f:
            for line in f:
                if "Failed password" in line:
                    ip = line.split()[-1]
                    failed[ip] += 1

                if "Invalid user" in line:
                    ip = line.split()[-1]
                    suspicious_ips.add(ip)
                    alerts.append({"type": "AUTH", "msg": line.strip()})

        for ip, count in failed.items():
            if count > 5:
                suspicious_ips.add(ip)
                alerts.append({"type": "AUTH_BRUTE", "ip": ip, "count": count})

    except Exception as e:
        alerts.append({"type": "ERROR", "msg": str(e)})


def detect_web():
    patterns = [r"union.*select", r"select.*from", r"drop", r"--", r"<script>", r"\.\./", r"/etc/passwd"]

    try:
        with open(apache_log) as f:
            for line in f:
                ip = line.split()[0]
                for p in patterns:
                    if re.search(p, line, re.IGNORECASE):
                        suspicious_ips.add(ip)
                        alerts.append({"type": "WEB_ATTACK", "pattern": p, "log": line.strip()})
                        break
    except Exception as e:
        alerts.append({"type": "ERROR", "msg": str(e)})


def detect_system():
    keywords = ["error", "failed", "segfault", "oom", "panic"]

    try:
        for file in [syslog, kern_log]:
            with open(file) as f:
                for line in f:
                    if any(k in line.lower() for k in keywords):
                        alerts.append({"type": "SYSTEM", "msg": line.strip()})
    except Exception as e:
        alerts.append({"type": "ERROR", "msg": str(e)})


detect_auth()
detect_web()
detect_system()

output = {
    "ips": list(suspicious_ips),
    "alerts": alerts[:20]
}

print(json.dumps(output))
