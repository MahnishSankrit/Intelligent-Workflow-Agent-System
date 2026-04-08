<%@ page import="java.util.List" %>
<%@ page import="model.User" %>

<html>
<head>
    <title>Dashboard</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: #f4f6f9;
        }

        /* Navbar */
        .navbar {
            background: #2c3e50;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* Container */
        .container {
            padding: 30px;
        }

        .card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        /* Buttons */
        .btn {
            display: inline-block;
            padding: 10px 15px;
            margin: 10px 10px 10px 0;
            border-radius: 5px;
            text-decoration: none;
            color: white;
            font-size: 14px;
            border: none;
            cursor: pointer;
        }

        .btn-blue { background: #3498db; }
        .btn-green { background: #2ecc71; }
        .btn-red { background: #e74c3c; }
        .btn-purple { background: #9b59b6; }

        .btn:hover {
            opacity: 0.9;
        }

        ul {
            padding-left: 20px;
        }

        .logout-container {
            text-align: center;
        }
    </style>
</head>

<body>

<%
User user = (User) session.getAttribute("user");

if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}

List<String> perms = (List<String>) session.getAttribute("permissions");
%>

<!-- Navbar -->
<div class="navbar">
    <div><strong>RBAC System</strong></div>
    <div>Welcome, <%= user.getName() %></div>
</div>

<div class="container">

    <!-- Role Info -->
    <div class="card">
        <h2>
            <% if (user.getRoleId() == 1) { %>
                Admin Dashboard
            <% } else { %>
                User Dashboard
            <% } %>
        </h2>
    </div>

    <!-- Actions -->
    <div class="card">
        <h3>Actions</h3>

        <% if (perms != null && perms.contains("CREATE_USER")) { %>
            <a href="manageUsers.jsp" class="btn btn-green">Add User</a>
        <% } %>

        <% if (perms != null && perms.contains("DELETE_USER")) { %>
            <a href="manageUsers.jsp" class="btn btn-red">Delete User</a>
        <% } %>

        <% if (perms != null && perms.contains("VIEW_REPORT")) { %>
            <a href="report.jsp" class="btn btn-blue">View Report</a>
        <% } %>
    </div>

    <!-- Permissions -->
    <div class="card">
        <h3>Your Permissions</h3>

        <ul>
        <%
        if (perms != null) {
            for (String p : perms) {
        %>
            <li><%= p %></li>
        <%
            }
        }
        %>
        </ul>
    </div>

    <!-- Logout -->
    <div class="card logout-container">
        <form action="logout" method="post">
            <button type="submit" class="btn btn-purple">
                Logout
            </button>
        </form>
    </div>

</div>

</body>
</html>