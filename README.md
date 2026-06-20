# 🐧 Nginx Log Analyzer - Bash DevOps Project

## 📌 Overview
This project is a **Bash-based Nginx log analyzer tool** designed for DevOps and system administration tasks.  
It parses access logs and generates a detailed report containing insights about traffic, performance, and suspicious behavior.

The project follows **best practices** like modular functions, strict error handling, and automated report generation.

---

## ⚙️ Features

- 📊 Total number of requests
- 🌍 Top visitor IP addresses
- 🔗 Most requested endpoints
- 📌 HTTP status code analysis
- ⚠️ Error rate calculation (4xx & 5xx)
- 🚨 Suspicious IP detection (threshold-based)
- 🧾 Auto-generated timestamped reports
- 📁 Stores reports in `reports/` directory
- 🛡️ Safe execution using `set -euo pipefail`

---

## 🧑‍💻 Technologies Used

- Bash Shell Scripting 🐚
- Linux CLI Tools:
  - awk
  - grep
  - sort
  - uniq
  - wc
- Nginx Access Log Format

---

## 🚀 How to Use

### 1. Give execution permission

chmod +x nginx_log_analyzer.sh 

2. Run the script

./nginx_log_analyzer.sh /path/to/nginx/access.log

📂 Output

All reports are saved automatically in:

reports/nginx_report_<timestamp>.txt

Example:

reports/nginx_report_2026-05-12_15-40-10.txt
📊 Sample Output
===============================
   NGINX LOG ANALYZER
 Date: Tue May 12 15:40:10 2026
===============================

📊 Total Requests:
12000
---
🌍 Top IPs:
192.168.1.10  500
10.0.0.5      420
----
📌 Status Codes:
200  11000

404  800
500  200
---
🔗 Top Endpoints:
/home   6000
/login  3500
---
⚠️ Error Rate:
Total: 12000 | Errors: 1000 | Error Rate: 8.33%
---
🚨 Suspicious IPs (>50 requests):
192.168.1.10  500
