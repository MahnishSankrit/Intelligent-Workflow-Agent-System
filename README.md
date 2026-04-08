
# Intelligent Workflow Agent System (IWAS)

A **behavior-driven intelligent workflow manager** built on top of a secure **Role-Based Access Control (RBAC)** foundation. Built with **Java Servlets, JSP, MySQL, and Maven**, IWAS manages organizational workflows by treating core roles (**Employee, Manager, Admin**) as *active agents* that monitor tasks, analyze operational risk, and surface actionable recommendations in real-time.

> **What “Intelligent” means here:** IWAS uses an internal **Intelligence Engine** (rule + metric driven) to compute overdue tasks, workload pressure, productivity risk, and recommendations from live database state.

---

## 🎯 Abstract

The Intelligent Workflow Agent System (IWAS) evolves traditional RBAC into an active, intelligent environment. Instead of static permissions alone, IWAS incorporates an **Intelligence Engine** that continuously evaluates task and employee signals. It automatically detects overdue work, calculates workload risks, tracks productivity metrics, and provides AI-style, actionable recommendations dynamically.

The application is wrapped in a premium, glassmorphism-inspired dark-mode UI for a modern, responsive experience across administrative interfaces.

---

## ✨ Core Features & Agent Behaviors

The system provides 5 core behaviors driven by the internal Intelligence Engine:

1. **Monitoring Agent:** Scans tasks to calculate progress and flag/mark overdue deadlines.
2. **Workload Agent:** Counts active tasks per employee to identify overloaded users.
3. **Productivity Agent:** Computes delay ratios to generate numeric risk signals (productivity risk).
4. **Recommendation Agent:** Generates suggestions (e.g., *reassign tasks from overloaded to least-loaded users*) based on workload disparity.
5. **Notification Agent:** Aggregates and routes intelligent alerts to the correct role-based dashboard.

### Role-Specific Environments
- **Admin Agent:** Manages RBAC, users, and system-wide risk/analytics views.
- **Manager Agent:** Assigns tasks, monitors team workload, and receives reassignment suggestions.
- **Employee Agent:** Updates task status and receives personal alerts (overdue / heavy workload).

---

## 🏗️ System Architecture & Stack

**Technologies Used:**
- **Frontend:** JSP, HTML5, Vanilla CSS (Custom Premium Dark Theme)
- **Backend:** Java Servlets (**Java 17** via Maven compiler settings)
- **Intelligence Layer:** Java Service (`IntelligenceEngine.java`)
- **Database:** MySQL
- **Build System:** Apache Maven
- **Server:** Embedded Tomcat (via Maven plugin)


JSP (Premium Dark UI)
        ↓
Servlets (TaskServlet, AgentServlet, AuthControl)
        ↓
IntelligenceEngine (Behavioral Analytics)  ↔  DAOs (Data Access)
        ↓
MySQL Database (iwas_db)


---

## 📂 Project Structure


IWAS/
│
├── src/main/java/
│   ├── agent/             # Core intelligence logic (IntelligenceEngine.java)
│   ├── controller/        # Servlets (Login, Tasks, Agents, AuthFilter)
│   ├── dao/               # Database Access Objects
│   ├── model/             # Entities (Task, TaskLog, EmployeeStat, User)
│   └── util/              # Database Connection and Helpers
│
├── src/main/webapp/
│   ├── css/style.css      # Premium Design System
│   └── *.jsp              # Role-based Web Pages & Dashboards
│
├── src/main/resources/
│   ├── schema.sql         # Full Database Structure and Seed Data
│   └── config.properties  # Database credentials
│
├── pom.xml                # Maven Dependencies & Build Configuration
└── .gitignore             # Secure ignores (target/, .properties, etc.)


---

## 🚀 Getting Started

### ✅ Prerequisites
- **Java 17**
- **Maven 3.x**
- **MySQL 8.x** (recommended)

---

### 1. Database Setup
1. Start MySQL.
2. Open your MySQL client.
3. Source the provided schema script (creates DB, tables, and seed data):

```sql
source src/main/resources/schema.sql
```

*(Ensure your `src/main/resources/config.properties` matches your local MySQL credentials.)*

---

### 2. Configure Database Credentials
Edit:

- `src/main/resources/config.properties`

Example:
```properties
db.url=jdbc:mysql://localhost:3306/iwas_db
db.user=root
db.password=your_password
```

---

### 3. Build and Run Server Locally
This project uses Maven with an embedded Tomcat plugin.

Run:
```bash
mvn tomcat7:run
```

---

### 4. Access Application
Navigate to:
- **http://localhost:8080/IWAS/**

---

### Default Test Credentials
| Role | Email | Password |
|------|-------|----------|
| **Admin** | admin@iwas.com | admin123 |
| **Manager** | manager@iwas.com | manager123 |
| **Employee** | emp1@iwas.com | emp123 |

---

## 🔒 Security Posture

- **Secured Credentials:** Database configs are intended to be isolated in `.properties` files and excluded via `.gitignore`.
- **RBAC Filter Interception:** Servlet `AuthFilter` protects task + intelligence endpoints from unauthenticated access.
- **Role Validation:** UI + backend endpoints validate session role IDs before returning agent insights.

> Recommendation: for production-style security, avoid committing real passwords; use environment variables / secrets and keep a `config.properties.example` file instead.

---

## 🧠 Intelligence Engine (What it evaluates)

At a high level, the engine reads system state and derives:

- **Overdue detection** → tasks marked as overdue and surfaced in dashboards
- **Workload pressure** → overloaded employees based on active workload thresholds
- **Productivity risk** → delay ratios / risk-style metrics from task completion history
- **Recommendations** → human-readable suggestions to rebalance workload and reduce risk

This gives the workflow system “agent-like” behavior: it doesn’t just store tasks—it continuously evaluates and advises.

---

## 🧯 Troubleshooting

- **DB connection errors**
  - Confirm MySQL is running
  - Verify `config.properties` values
  - Ensure the `iwas_db` database exists (re-run `schema.sql` if needed)

- **Port 8080 already in use**
  - Stop the conflicting service or change the port in the Maven Tomcat plugin configuration in `pom.xml`

- **Tables missing / empty**
  - Re-run:
    ```sql
    source src/main/resources/schema.sql
    ```

---

## 📌 Roadmap (Optional Enhancements)

- Add screenshots/GIFs of Admin/Manager/Employee dashboards
- Add tests for DAO layer and `IntelligenceEngine`
- Replace committed credentials with a safe local config approach (`config.properties.example`)
- Add a role-permission matrix table to document RBAC clearly
```
