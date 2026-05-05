# 🔐 AI-Powered Linux Security Monitoring System

## 📌 Overview

This project is an **AI-driven security monitoring and response system** for Linux servers.
It continuously monitors system activity, detects suspicious behavior, and automatically responds to threats.

The system integrates log analysis, system monitoring, and AI-based decision making using a local LLM.

---

## 🚀 Features

### 🔍 Real-Time Monitoring

* CPU, RAM, Disk usage tracking
* Logs system metrics continuously

### 🛡️ Threat Detection

* SSH brute-force detection
* Web attack detection (SQLi, XSS, path traversal)
* System error detection

### 🤖 AI Analysis

* Uses local AI (Ollama) for:

  * Threat classification
  * Severity detection
  * Action recommendation

### ⚡ Automated Response

* Blocks malicious IPs using iptables
* Restarts failed services (Apache, MySQL)
* Sends alerts via Telegram

### 📩 Alerting System

* Real-time notifications to Telegram

---

## 🏗️ Architecture

```
Monitor → Log Analyzer → AI Engine → Decision → Action → Alert
```

---

## 🐳 Docker Setup

### Requirements

* Docker
* Docker Compose

### Run the system

```bash
docker-compose up -d --build
```

---

## ⚙️ Configuration

Create a `.env` file:

```
TELEGRAM_TOKEN=your_token_here
TELEGRAM_CHAT_ID=your_chat_id
```

---

## 📂 Project Structure

```
xsec/
├── docker-compose.yml
├── Dockerfile
├── scripts/
│   ├── main.sh
│   ├── monitor.sh
│   ├── log_analyser.py
│   ├── ai.py
│   ├── ip_block.sh
│   ├── resover.sh
│   └── alert.py
├── logs/
```

---

## 🧪 Testing

### Simulate brute-force attack

```bash
echo "Failed password for root from 1.2.3.4 port 22 ssh2" >> /var/log/auth.log
```

---

## ⚠️ Security Notes

* Do NOT expose your `.env` file
* Run container with proper privileges for iptables
* Use this only in controlled environments

---

## 🎯 Use Cases

* Server security monitoring
* DevSecOps automation
* SOC simulation environment
* Learning penetration testing defense

---

## 👨‍💻 Author

**Rohit Sudhakaran**
Linux admin | Penetration Tester

---

## 📜 License

This project is for educational and research purposes only.
