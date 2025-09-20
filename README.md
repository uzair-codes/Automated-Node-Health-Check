# Automated-Node-Health-Check
---

````markdown
# Automated Remote Node Health Check (Multi-Node)

A **Bash script** to automatically check the health of one or multiple remote Linux nodes.  
It performs ping reachability, logs in via SSH (using a PEM key), runs key system health commands, fetches the report locally, and saves it with a timestamp in a `./reports/` folder — with **beautiful color-coded output** for better readability.

---

## Features

✅ **Interactive Mode** – Run health check for a single node  
✅ **Multi-Node Mode** – Provide a file with multiple IPs  
✅ **Color-Coded Output** – Highlights UP/DOWN status and report headings  
✅ **Detailed Health Checks** – Uptime, CPU, memory, disk usage, and top processes  
✅ **Local Logging** – Saves timestamped reports in `./reports/` folder  
✅ **Beginner-Friendly** – Includes helper function and error messages for incorrect usage  

---

## 📦 Prerequisites

Before running this script, ensure:

- You have **SSH access** to your remote nodes.
- You have a valid **PEM key file** (or SSH key pair).
- `bash`, `ssh`, `scp`, and `ping` are available on your system (default on Linux/macOS).
- For multiple nodes: You have a file (e.g., `nodes.txt`) containing **one IP address per line**.

---

## Installation & Setup

Clone the repository:

```bash
git clone https://github.com/uzair-codes/Automated-Node-Health-Check.git
cd Automated-Node-Health-Check
````

Make the script executable:

```bash
chmod +x nodeHealth.sh
```

---

## 🖥️ Usage

You can run the script in two modes:

### 🔹 1. Single Node Mode (Interactive)

```bash
./nodeHealth.sh
```

It will prompt you for:

* Node IP address
* Remote username (e.g., `ec2-user`, `ubuntu`)
* Path to PEM key file

---

### 🔹 2. Multi-Node Mode (From File)

Create a file with one IP per line, e.g.:

**nodes.txt**

```
192.168.1.10
192.168.1.11
192.168.1.12
```

Run the script with:

```bash
./nodeHealth.sh -f nodes.txt
```

The script will loop through each IP and generate individual health reports.

---

## 📊 Example Output

```
=========================================
Checking Node: 192.168.1.10
Date: Sat Sep 20 09:42:11 PKT 2025
=========================================
Node 192.168.1.10 is UP

===== Health Report for 192.168.1.10 =====
====================
 Node Health Report
====================
Hostname: ip-192-168-1-10
Date: Sat Sep 20 09:42:13 PKT 2025

---- Uptime ----
 09:42:13 up 10 days,  5:32,  1 user,  load average: 0.01, 0.05, 0.00

---- CPU Load ----
 0.01 0.05 0.00

---- Memory Usage ----
              total        used        free      shared  buff/cache   available
Mem:           981M        210M        520M        8.0M        250M        682M

---- Disk Usage ----
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvda1       20G  3.2G   17G  16% /

---- Top 5 Processes by CPU ----
  PID  PPID CMD                         %MEM %CPU
  101     1 /usr/bin/containerd           0.1  2.3
  215   101 /usr/bin/dockerd              0.2  1.1

---- Top 5 Processes by Memory ----
  PID  PPID CMD                         %MEM %CPU
  215   101 /usr/bin/dockerd              0.2  1.1
```

---

## 🗂️ Report Storage

All reports are automatically saved under `./reports/` with a timestamped filename:

```
reports/
├── health_report_192.168.1.10_20250920_094213.txt
├── health_report_192.168.1.11_20250920_094220.txt
└── health_report_192.168.1.12_20250920_094225.txt
```

---

## 🔧 Troubleshooting

* **Permission denied (publickey):**
  Ensure the correct PEM key path is provided and permissions are set:

  ```bash
  chmod 400 my-key.pem
  ```

* **Script not executing:**
  Make sure it has execute permission:

  ```bash
  chmod +x nodeHealth.sh
  ```

* **File not found error for nodes file:**
  Ensure the file exists and contains one IP per line.

---

## 🤝 Contributing

Feel free to fork this repo, open issues, or submit pull requests if you’d like to add more features (e.g., email alerts, Slack notifications, or Docker container support).

---

## 📜 License

This project is licensed under the **MIT License** – feel free to use, modify, and share.

---

## 👨‍💻 Author

**Uzair**
🔗 [GitHub Profile](https://github.com/uzair-codes)

---

```

---
### ✅ Why This README Stands Out:
- **Clear intro & purpose** – anyone landing on your repo instantly knows what it does.
- **Step-by-step instructions** – perfect for beginners.
- **Example output** – lets users see what to expect.
- **Troubleshooting section** – proactive support for common errors.
- **Professional formatting** – uses headings, icons, and code blocks for readability.
---

```

