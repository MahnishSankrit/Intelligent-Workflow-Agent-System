<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IWAS — Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<%
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}
List<String> perms = (List<String>) session.getAttribute("permissions");
int roleId = user.getRoleId();
String roleName = roleId == 1 ? "Admin" : (roleId == 2 ? "Manager" : "Employee");
String roleClass = roleName.toLowerCase();

// Fetch some quick stats
int totalUsers = 0, totalTasks = 0, overdueTasks = 0, activeTasks = 0;
try {
    Connection con = DBConnection.getConnection();
    Statement stmt = con.createStatement();

    ResultSet r1 = stmt.executeQuery("SELECT COUNT(*) FROM users");
    if (r1.next()) totalUsers = r1.getInt(1);

    ResultSet r2 = stmt.executeQuery("SELECT COUNT(*) FROM tasks");
    if (r2.next()) totalTasks = r2.getInt(1);

    ResultSet r3 = stmt.executeQuery("SELECT COUNT(*) FROM tasks WHERE status='overdue' OR (deadline < CURDATE() AND status NOT IN ('completed','overdue'))");
    if (r3.next()) overdueTasks = r3.getInt(1);

    if (roleId == 3) {
        PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM tasks WHERE assigned_to=? AND status IN ('pending','in_progress')");
        ps.setInt(1, user.getId());
        ResultSet r4 = ps.executeQuery();
        if (r4.next()) activeTasks = r4.getInt(1);
    } else {
        ResultSet r4 = stmt.executeQuery("SELECT COUNT(*) FROM tasks WHERE status IN ('pending','in_progress')");
        if (r4.next()) activeTasks = r4.getInt(1);
    }

    con.close();
} catch (Exception e) {
    e.printStackTrace();
}
%>

<div class="page-wrapper">

    <!-- Navbar -->
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

        <!-- Page Header -->
        <div class="page-header">
            <h1>
                <% if (roleId == 1) { %>
                    &#x1F6E1; Admin Dashboard
                <% } else if (roleId == 2) { %>
                    &#x1F4CB; Manager Dashboard
                <% } else { %>
                    &#x1F4BC; Employee Dashboard
                <% } %>
            </h1>
            <div class="nav-links">
                <a href="tasks" class="btn btn-primary btn-sm">&#x1F4DD; Tasks</a>
                <a href="agent" class="btn btn-info btn-sm">&#x1F9E0; Agent Insights</a>
                <% if (perms != null && perms.contains("CREATE_USER")) { %>
                    <a href="manageUsers.jsp" class="btn btn-success btn-sm">&#x1F465; Manage Users</a>
                <% } %>
                <% if (perms != null && perms.contains("MANAGE_ROLES")) { %>
                    <a href="manageRoles.jsp" class="btn btn-warning btn-sm">&#x1F511; Manage Roles</a>
                <% } %>
                <% if (perms != null && perms.contains("VIEW_REPORT")) { %>
                    <a href="report.jsp" class="btn btn-ghost btn-sm">&#x1F4CA; System Report</a>
                <% } %>
            </div>
        </div>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value"><%= roleId == 3 ? activeTasks : totalUsers %></div>
                <div class="stat-label"><%= roleId == 3 ? "My Active Tasks" : "Total Users" %></div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= totalTasks %></div>
                <div class="stat-label">Total Tasks</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= activeTasks %></div>
                <div class="stat-label"><%= roleId == 3 ? "Pending" : "Active Tasks" %></div>
            </div>
            <div class="stat-card">
                <div class="stat-value" style="<%= overdueTasks > 0 ? "-webkit-text-fill-color: #ef4444;" : "" %>"><%= overdueTasks %></div>
                <div class="stat-label">Overdue</div>
            </div>
        </div>

        <!-- Quick Actions & Permissions -->
        <div class="content-grid">
            <!-- Quick Actions -->
            <div class="card">
                <div class="card-header">
                    <h3><span class="card-icon purple">&#x26A1;</span> Quick Actions</h3>
                </div>
                <div class="nav-links" style="flex-direction: column;">
                    <a href="tasks" class="btn btn-primary w-full">&#x1F4DD; View & Manage Tasks</a>
                    <a href="agent" class="btn btn-info w-full">&#x1F9E0; View Agent Intelligence</a>
                    <% if (roleId <= 2) { %>
                        <a href="tasks" class="btn btn-success w-full">&#x2795; Create New Task</a>
                    <% } %>
                    <% if (roleId == 1) { %>
                        <a href="manageUsers.jsp" class="btn btn-warning w-full">&#x1F465; User Management</a>
                    <% } %>
                </div>
            </div>

            <!-- Permissions Card -->
            <div class="card">
                <div class="card-header">
                    <h3><span class="card-icon green">&#x1F512;</span> Your Permissions</h3>
                </div>
                <div style="display: flex; flex-wrap: wrap; gap: 8px;">
                <%
                if (perms != null) {
                    for (String p : perms) {
                %>
                    <span class="status-badge completed"><%= p %></span>
                <%
                    }
                }
                %>
                </div>
            </div>
        </div>

    </div>
</div>

</body>
</html>