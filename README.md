# 🚛 Fleet Telematics & Analytics Microservice

A two-tier, containerized microservice built with **Flask**, **PostgreSQL**, and **Docker Compose** designed to ingest vehicle telemetry logs in real time and serve fleet-wide KPI analytics.

![System Architecture](diagrams/architecture.svg)

---

## 🌟 Key Features

* **Real-time Telemetry Ingestion:** RESTful API endpoint to accept vehicle telemetry data (`vehicle_id`, `speed`, `fuel_level`).
* **Automated Status Calculation:** Dynamic status flagging (`ACTIVE`, `SPEEDING`, `LOW_FUEL`, `IDLE`) based on telemetry parameters.
* **KPI & Analytics Dashboard:** Visual dashboard rendering fleet metrics including active vehicle count, average speeds, fuel averages, and safety alerts.
* **PostgreSQL Integration:** Persistent relational storage using SQLAlchemy ORM and structured PostgreSQL schema indexing.
* **Containerized Orchestration:** Multi-container setup managed via Docker Compose with dynamic database retry logic.
* **CI/CD Integration:** Automated build and testing workflows via GitHub Actions and Jenkins.

---

## 🏗️ Architecture & Tech Stack

* **Backend:** Python (Flask, Flask-SQLAlchemy)
* **Database:** PostgreSQL 15
* **Containerization:** Docker, Docker Compose
* **CI/CD:** GitHub Actions, Jenkins
* **Frontend:** HTML5, CSS3, Jinja2 Templates

---

## 🚀 Quick Start Guide

### Prerequisites

* [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running on your machine.

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/YOUR_GITHUB_USERNAME/flask-telematics-app.git](https://github.com/YOUR_GITHUB_USERNAME/flask-telematics-app.git)
   cd flask-telematics-app