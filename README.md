# Role-Based Access Control (RBAC) System

A **web-based Role-Based Access Control (RBAC)** application built using **Java Servlets, JSP, and MySQL**.  
This system manages user access efficiently by assigning **roles** to users and **permissions** to roles (instead of assigning permissions directly to users).

---

## Mini Project Report

**Submitted by:** [Your Name]  
**Course:** [Your Course Name]  
**Under Guidance of:** [Teacher Name]  
**College:** [Your College Name]  
**Year:** 2026  

---

## Abstract

The Role-Based Access Control (RBAC) System is a web-based application developed using Java Servlets, JSP, and MySQL. The system is designed to manage user access efficiently by assigning roles and permissions. Instead of assigning permissions directly to users, permissions are associated with roles, and users are assigned roles.

The system ensures secure authentication and authorization, allowing users to perform only permitted actions. Admin users can manage roles, permissions, and users dynamically. This approach improves scalability, security, and maintainability of access control in an organization.

---

## Objectives

- To implement secure user authentication and authorization  
- To manage roles and permissions dynamically  
- To restrict access based on user roles  
- To provide an admin panel for managing users and roles  
- To ensure data security and controlled access  

---

## System Overview

The system follows the RBAC model where:
- **Users** are assigned **Roles**
- **Roles** are associated with **Permissions**
- A user’s allowed actions are based on the permissions of their assigned role

When a user logs in, the system verifies credentials and retrieves the role and permissions associated with that user.

Based on these permissions, the system dynamically controls access to features such as adding users, deleting users, and viewing reports.

---

## Working Flow

1. User logs in using email and password  
2. System authenticates user from database  
3. User is assigned a role (Admin/User)  
4. Permissions are fetched based on role  
5. Permissions are stored in session  
6. Dashboard displays allowed actions  
7. User can only access permitted features  
8. Unauthorized access is restricted  

---

## System Architecture

```
JSP (Frontend/UI)
        ↓
Servlet (Controller Layer)
        ↓
DAO (Database Access Layer)
        ↓
MySQL Database
```

---

## Project Structure

```
RBAC-System/
│
├── controller/ (Servlets)
│   ├── AuthServlet.java
│   ├── UserServlet.java
│   ├── RoleServlet.java
│   ├── PermissionServlet.java
│
├── dao/
│   ├── UserDAO.java
│   ├── RoleDAO.java
│   ├── PermissionDAO.java
│
├── model/
│   ├── User.java
│   ├── Role.java
│   ├── Permission.java
│
├── util/
│   ├── DBConnection.java
│
├── jsp/
│   ├── login.jsp
│   ├── dashboard.jsp
│   ├── manageUsers.jsp
│   ├── manageRoles.jsp
│   ├── managePermissions.jsp
│
└── web.xml
```

---

## Modules Description

### 1. Authentication Module
- Handles user login  
- Validates credentials from database  
- Creates session for logged-in user  

### 2. User Management Module
- Admin can add new users  
- Admin can delete users  
- Role is assigned during user creation  

### 3. Role Management Module
- Admin can view roles  
- Admin can assign permissions to roles  
- Roles define access levels  

### 4. Permission Module
- Permissions define actions like `CREATE_USER`, `DELETE_USER`  
- Permissions are linked to roles  
- Used for access control  

### 5. Report Module
- Displays system summary  
- Shows total users, roles, permissions  

### 6. Logout Module
- Ends user session  
- Redirects to login page  

---

## Database Design

### Tables Used

1. **users**
   - `id, name, email, password, role_id`

2. **roles**
   - `id, name`

3. **permissions**
   - `id, name`

4. **role_permissions**
   - `role_id, permission_id`

---

## Security Features

- Session-based authentication  
- Role-based authorization  
- Permission validation before actions  
- Restricted access for unauthorized users  

---

## Technologies Used

- **Frontend:** JSP, HTML, CSS  
- **Backend:** Java Servlets  
- **Database:** MySQL  
- **Server:** Apache Tomcat  
- **IDE:** Eclipse  

---

## Limitations

- No user-based permission assignment (only role-based)  
- No permission request system  
- No audit logging  

---

## Future Enhancements

- Add user permission request feature  
- Implement role hierarchy (Admin > Manager > User)  
- Add audit logs for tracking activities  
- Improve UI using modern frameworks  

---

## Conclusion

The RBAC system successfully demonstrates secure and scalable access control using roles and permissions. It ensures that users can only perform actions they are authorized for, improving system security and management.

This project provides a strong foundation for building enterprise-level access control systems.
