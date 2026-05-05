import requests
import sys
import json

OLLAMA_URL = "http://localhost:11434/api/generate"

def analyze(data):
    prompt = f"""
You are a SOC analyst.

Analyze this system + security data:

{json.dumps(data, indent=2)}

Tasks:
- detect attacks (brute force, web attacks)
- detect system overload (cpu, ram, disk)
- correlate issues (DoS, resource abuse)
- assign severity: LOW/MEDIUM/HIGH/CRITICAL
- suggest action: block / restart_service / alert / monitor

Return ONLY JSON:
{{
 "threats": [],
 "severity": "",
 "action": "",
 "reason": ""
}}
"""

    payload = {
        "model": "llama3",
        "prompt": prompt,
        "stream": False
    }

    try:
        res = requests.post(OLLAMA_URL, json=payload, timeout=25)
        return res.json()["response"]
    except:
        return '{"action":"monitor"}'

if __name__ == "__main__":
    data = json.loads(sys.stdin.read())
    print(analyze(data))
