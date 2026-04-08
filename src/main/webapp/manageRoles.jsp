<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IWAS — Manage Roles</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<%
User user = (User) session.getAttribute("user");
if (user == null || user.getRoleId() != 1) {
    response.sendRedirect("accessDenied.jsp");
    return;
}
%>

<div class="page-wrapper">

    <nav class="navbar">
        <div class="navbar-brand">
            <div class="brand-icon">&#x1F916;</div>
            IWAS
        </div>
        <div class="navbar-right">
            <span class="role-badge admin">Admin</span>
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
            <h1>&#x1F511; Role & Permission Management</h1>
            <div class="nav-links">
                <a href="dashboard.jsp" class="btn btn-ghost btn-sm">&#x2190; Dashboard</a>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3><span class="card-icon yellow">&#x1F511;</span> Assign Permissions to Role</h3>
            </div>

            <form action="assignPermission" method="post">

                <div class="form-group">
                    <label for="roleId">Select Role</label>
                    <select id="roleId" name="roleId">
                    <%
                    Connection con = DBConnection.getConnection();
                    Statement roleStmt = con.createStatement();
                    ResultSet rs = roleStmt.executeQuery("SELECT * FROM roles");
                    while (rs.next()) {
                    %>
                        <option value="<%= rs.getInt("id") %>"><%= rs.getString("name") %></option>
                    <%
                    }
                    %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Select Permissions</label>
                    <div style="display: flex; flex-wrap: wrap; gap: 12px; margin-top: 8px;">
                    <%
                    Statement permStmt = con.createStatement();
                    ResultSet prs = permStmt.executeQuery("SELECT * FROM permissions");
                    while (prs.next()) {
                    %>
                        <label style="display: flex; align-items: center; gap: 6px; cursor: pointer; color: var(--text-primary); font-size: 0.9rem;">
                            <input type="checkbox" name="permissions" value="<%= prs.getInt("id") %>"
                                   style="width: auto; margin: 0; accent-color: var(--accent-primary);">
                            <%= prs.getString("name") %>
                        </label>
                    <%
                    }
                    con.close();
                    %>
                    </div>
                </div>

                <button type="submit" class="btn btn-warning w-full mt-2">&#x1F4E4; Assign Permissions</button>

            </form>
        </div>

    </div>
</div>

</body>
</html>