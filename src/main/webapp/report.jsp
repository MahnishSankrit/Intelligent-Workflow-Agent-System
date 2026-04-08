<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IWAS — System Report</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<%
User user = (User) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }
int roleId = user.getRoleId();
String roleName = roleId == 1 ? "Admin" : (roleId == 2 ? "Manager" : "Employee");
String roleClass = roleName.toLowerCase();

int totalUsers = 0, totalRoles = 0, totalPermissions = 0, totalTasks = 0, completedTasks = 0, overdueTasks = 0;
try {
    Connection con = DBConnection.getConnection();
    Statement stmt = con.createStatement();

    ResultSet rs1 = stmt.executeQuery("SELECT COUNT(*) FROM users");
    if (rs1.next()) totalUsers = rs1.getInt(1);

    ResultSet rs2 = stmt.executeQuery("SELECT COUNT(*) FROM roles");
    if (rs2.next()) totalRoles = rs2.getInt(1);

    ResultSet rs3 = stmt.executeQuery("SELECT COUNT(*) FROM permissions");
    if (rs3.next()) totalPermissions = rs3.getInt(1);

    ResultSet rs4 = stmt.executeQuery("SELECT COUNT(*) FROM tasks");
    if (rs4.next()) totalTasks = rs4.getInt(1);

    ResultSet rs5 = stmt.executeQuery("SELECT COUNT(*) FROM tasks WHERE status='completed'");
    if (rs5.next()) completedTasks = rs5.getInt(1);

    ResultSet rs6 = stmt.executeQuery("SELECT COUNT(*) FROM tasks WHERE status='overdue' OR (deadline < CURDATE() AND status NOT IN ('completed','overdue'))");
    if (rs6.next()) overdueTasks = rs6.getInt(1);

    con.close();
} catch (Exception e) { e.printStackTrace(); }
%>

<div class="page-wrapper">

    <nav class="navbar">
        <div class="navbar-brand">
            <div class="brand-icon">&#x1F916;</div>
            IWAS
        </div>
        <div class="navbar-right">
            <span class="role-badge <%= roleClass %>"><%= roleName %></span>
            <div class="navbar-user">
                <div class="avatar"><%= user.getName().substring(0, 1).toUpperCase() %></div>
                <span><%= user.getName() %></span>
            </div>
            <form action="logout" method="post" style="margin:0;">
                <button type="submit" class="btn btn-ghost btn-sm">&#x1F6AA; Logout</button>
            </form>
        </div>
    </nav>

    <div class="container">

        <div class="page-header">
            <h1>&#x1F4CA; System Report</h1>
            <div class="nav-links">
                <a href="dashboard.jsp" class="btn btn-ghost btn-sm">&#x2190; Dashboard</a>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value"><%= totalUsers %></div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= totalRoles %></div>
                <div class="stat-label">Roles</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= totalPermissions %></div>
                <div class="stat-label">Permissions</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= totalTasks %></div>
                <div class="stat-label">Total Tasks</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= completedTasks %></div>
                <div class="stat-label">Completed</div>
            </div>
            <div class="stat-card">
                <div class="stat-value" style="<%= overdueTasks > 0 ? "-webkit-text-fill-color: #ef4444;" : "" %>"><%= overdueTasks %></div>
                <div class="stat-label">Overdue</div>
            </div>
        </div>

    </div>
</div>

</body>
</html>