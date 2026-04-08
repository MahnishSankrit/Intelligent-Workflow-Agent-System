-- ============================================
-- IWAS - Intelligent Workflow Agent System
-- Database Initialization Script
-- ============================================

CREATE DATABASE IF NOT EXISTS iwas_db;
USE iwas_db;

-- =====================
-- Core Tables (kept from original RBAC)
-- =====================

CREATE TABLE IF NOT EXISTS roles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS permissions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS role_permissions (
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role_id INT NOT NULL,
    FOREIGN KEY (role_id) REFERENCES roles(id)
);

-- =====================
-- IWAS Agent Tables
-- =====================

CREATE TABLE IF NOT EXISTS tasks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    assigned_to INT,
    assigned_by INT,
    status ENUM('pending', 'in_progress', 'completed', 'overdue') DEFAULT 'pending',
    priority ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
    deadline DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (assigned_by) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS task_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    task_id INT NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS employee_stats (
    employee_id INT PRIMARY KEY,
    tasks_completed INT DEFAULT 0,
    tasks_delayed INT DEFAULT 0,
    FOREIGN KEY (employee_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =====================
-- Seed Data
-- =====================

-- Roles: 1=Admin, 2=Manager, 3=Employee
INSERT INTO roles (id, name) VALUES
    (1, 'Admin'),
    (2, 'Manager'),
    (3, 'Employee')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- Permissions
INSERT INTO permissions (id, name) VALUES
    (1, 'CREATE_USER'),
    (2, 'DELETE_USER'),
    (3, 'VIEW_REPORT'),
    (4, 'MANAGE_ROLES'),
    (5, 'CREATE_TASK'),
    (6, 'ASSIGN_TASK'),
    (7, 'UPDATE_TASK'),
    (8, 'VIEW_TASKS'),
    (9, 'VIEW_ANALYTICS'),
    (10, 'VIEW_AGENT_INSIGHTS')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- Admin gets all permissions
INSERT IGNORE INTO role_permissions (role_id, permission_id) VALUES
    (1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10);

-- Manager gets task + insight permissions
INSERT IGNORE INTO role_permissions (role_id, permission_id) VALUES
    (2, 3), (2, 5), (2, 6), (2, 7), (2, 8), (2, 10);

-- Employee gets task view/update
INSERT IGNORE INTO role_permissions (role_id, permission_id) VALUES
    (3, 7), (3, 8);

-- Default users (password stored as plain text for demo)
INSERT INTO users (name, email, password, role_id) VALUES
    ('Admin User', 'admin@iwas.com', 'admin123', 1),
    ('Manager One', 'manager@iwas.com', 'manager123', 2),
    ('Employee Alpha', 'emp1@iwas.com', 'emp123', 3),
    ('Employee Beta', 'emp2@iwas.com', 'emp123', 3),
    ('Employee Gamma', 'emp3@iwas.com', 'emp123', 3)
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- Seed employee_stats
INSERT INTO employee_stats (employee_id, tasks_completed, tasks_delayed)
SELECT id, 0, 0 FROM users WHERE role_id = 3
ON DUPLICATE KEY UPDATE tasks_completed=tasks_completed;

-- Seed some demo tasks
INSERT INTO tasks (title, description, assigned_to, assigned_by, status, priority, deadline) VALUES
    ('Setup Dev Environment', 'Install all required tools and configure IDE', 3, 2, 'completed', 'high', DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
    ('Design Database Schema', 'Create ER diagram and SQL scripts', 3, 2, 'completed', 'high', DATE_SUB(CURDATE(), INTERVAL 3 DAY)),
    ('Implement Login Module', 'Build authentication with session management', 4, 2, 'in_progress', 'critical', DATE_ADD(CURDATE(), INTERVAL 2 DAY)),
    ('Write Unit Tests', 'Cover all DAO methods with tests', 4, 2, 'pending', 'medium', DATE_ADD(CURDATE(), INTERVAL 5 DAY)),
    ('Create Dashboard UI', 'Build responsive dashboard with charts', 5, 2, 'pending', 'high', DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
    ('API Documentation', 'Document all servlet endpoints', 5, 2, 'pending', 'low', DATE_ADD(CURDATE(), INTERVAL 10 DAY)),
    ('Security Audit', 'Review authentication and authorization', 3, 2, 'pending', 'critical', DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
    ('Performance Testing', 'Load test the application', 4, 2, 'pending', 'medium', DATE_ADD(CURDATE(), INTERVAL 7 DAY)),
    ('Deploy to Staging', 'Setup staging server and deploy', 3, 2, 'pending', 'high', DATE_ADD(CURDATE(), INTERVAL 3 DAY)),
    ('Code Review', 'Review pull requests from team', 5, 2, 'in_progress', 'medium', DATE_ADD(CURDATE(), INTERVAL 1 DAY))
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- Update employee stats for completed tasks
UPDATE employee_stats SET tasks_completed = 2, tasks_delayed = 1 WHERE employee_id = 3;
UPDATE employee_stats SET tasks_completed = 0, tasks_delayed = 0 WHERE employee_id = 4;
UPDATE employee_stats SET tasks_completed = 0, tasks_delayed = 0 WHERE employee_id = 5;
