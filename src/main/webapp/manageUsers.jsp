<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="model.User" %>

<html>
<head>
    <title>User Management</title>

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

        h2, h3 {
            margin-top: 0;
        }

        /* Inputs */
        input, select {
            width: 100%;
            padding: 8px;
            margin: 5px 0 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        /* Buttons */
        .btn {
            padding: 10px 15px;
            border-radius: 5px;
            border: none;
            color: white;
            cursor: pointer;
        }

        .btn-green { background: #2ecc71; }
        .btn-red { background: #e74c3c; }
        .btn-blue { background: #3498db; }

        .btn:hover {
            opacity: 0.9;
        }

        .row {
            display: flex;
            gap: 20px;
        }

        .col {
            flex: 1;
        }

    </style>
</head>

<body>

<%
User user = (User) session.getAttribute("user");
List<String> perms = (List<String>) session.getAttribute("permissions");

// 🔒 Security
if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}

if (perms == null) {
    response.sendRedirect("accessDenied.jsp");
    return;
}
%>

<!-- Navbar -->
<div class="navbar">
    <div><strong>RBAC System</strong></div>
    <div>Welcome, <%= user.getName() %></div>
</div>

<div class="container">

    <h2>User Management</h2>

    <div class="row">

        <!-- ================= ADD USER ================= -->
        <% if (perms.contains("CREATE_USER")) { %>
        <div class="card col">
            <h3>Add User</h3>

            <form action="addUser" method="post">

                Name:
                <input type="text" name="name" required>

                Email:
                <input type="text" name="email" required>

                Password:
                <input type="password" name="password" required>

                Role:
                <select name="roleId">

                <%
                Connection con = DBConnection.getConnection();
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM roles");

                while (rs.next()) {
                %>
                    <option value="<%= rs.getInt("id") %>">
                        <%= rs.getString("name") %>
                    </option>
                <%
                }
                %>

                </select>

                <button class="btn btn-green" type="submit">Add User</button>

            </form>
        </div>
        <% } %>

        <!-- ================= DELETE USER ================= -->
        <% if (perms.contains("DELETE_USER")) { %>
        <div class="card col">
            <h3>Delete User</h3>

            <form action="deleteUser" method="post">

                User ID:
                <input type="number" name="userId" required>

                <button class="btn btn-red" type="submit">Delete User</button>

            </form>
        </div>
        <% } %>

    </div>

    <br>

    <!-- Back Button -->
    <a href="dashboard.jsp">
        <button class="btn btn-blue">← Back to Dashboard</button>
    </a>

</div>

</body>
</html>