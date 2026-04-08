# Intelligent Workflow Agent System (IWAS)

A **behavior-driven intelligent workflow manager** built on top of a secure Role-Based Access Control (RBAC) foundation. Developed using **Java Servlets, JSP, MySQL, and Maven**, IWAS manages entire corporate workflows by treating different roles (Employee, Manager, Admin) as intelligent agents that actively monitor, analyze, and recommend actions in real-time.

---

## 🎯 Abstract

The Intelligent Workflow Agent System (IWAS) evolves traditional RBAC into an active, intelligent environment. Instead of simple static permissions, IWAS incorporates an **Intelligence Engine** that continuously evaluates system data. It automatically detects overdue tasks, calculates employee workload risks, tracks productivity metrics, and surfaces actionable, AI-style recommendations dynamically. 

The application is wrapped in a premium, glassmorphism-inspired dark-mode UI, providing a modern and highly responsive user experience across all administrative interfaces.

---

## ✨ Core Features & Agent Behaviors

The system provides 5 core active behaviors driven by the internal Intelligence Engine:

1. **Monitoring Agent:** Autonomously scans task tables to calculate progress and flag overdue deadlines.
2. **Workload Agent:** Counts active tasks per employee to flag high-risk or overloaded users dynamically.
3. **Productivity Agent:** Computes "delay-to-completion" ratios to generate numeric Risk Scores for the workforce.
4. **Recommendation Agent:** Generates actionable suggestions (e.g., "Reassign tasks from User X to User Y") based on real-time workload disparity.
5. **Notification Agent:** Aggregates and routes intelligent alerts to the correct role-based dashboard.

### Role-Specific Environments
- **Admin Agent:** Manages global RBAC settings, users, and views system-wide risk metrics.
- **Manager Agent:** Assigns tasks, monitors team workload balancing, and receives reassignment suggestions.
- **Employee Agent:** Updates task status and receives personal alerts regarding overdue deadlines or heavy workloads.

---

## 🏗️ System Architecture & Stack

**Technologies Used:**
- **Frontend:** JSP, HTML5, Vanilla CSS (Custom Premium Dark Theme)
- **Backend:** Java Servlets (Java 17/21 compatible)
- **Intelligence Layer:** Reactive Java Services (`IntelligenceEngine.java`)
- **Database:** MySQL
- **Build System:** Apache Maven
- **Server:** Embedded Tomcat 7 (via Maven plugin)

```text
JSP (Premium Dark UI)
        ↓
Servlets (TaskServlet, AgentServlet, AuthControl)
        ↓
IntelligenceEngine (Behavioral Analytics)  ↔  DAOs (Data Access)
        ↓
MySQL Database (iwas_db)
```

---

## 📂 Project Structure

```text
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
│   └── config.properties  # Secured database credentials
│
├── pom.xml                # Maven Dependencies & Build Configuration
└── .gitignore             # Secure ignores (target/, .properties, etc.)
```

---

## 🚀 Getting Started

### 1. Database Setup
1. Open your MySQL client.
2. Source the provided schema script containing tables and seed data:
   ```sql
   source src/main/resources/schema.sql
   ```
*(Make sure your `src/main/resources/config.properties` contains your matching database credentials).*

### 2. Build and Run Server Locally
Since the project utilizes Maven with an embedded Tomcat plugin, you do not need to install a standalone server. 

Run the executable from your terminal:
```bash
mvn tomcat7:run
```

### 3. Access Application
Open your browser and navigate to:
👉 **[http://localhost:8080/IWAS/](http://localhost:8080/IWAS/)**

### Default Test Credentials
| Role | Email | Password |
|------|-------|----------|
| **Admin** | admin@iwas.com | admin123 |
| **Manager** | manager@iwas.com | manager123 |
| **Employee** | emp1@iwas.com | emp123 |

---

## 🔒 Security Posture

- **Secured Credentials:** Database configurations are isolated in `.properties` files excluded via `.gitignore`.
- **RBAC Filter Interception:** Core servlet `AuthFilter` protects all intelligence and task endpoints from unauthenticated access.
- **Role Validation:** UI and backend endpoints strictly validate session role IDs before returning agent insights.
