<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IWAS — User Management</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<%
User user = (User) session.getAttribute("user");
List<String> perms = (List<String>) session.getAttribute("permissions");
if (user == null) { response.sendRedirect("login.jsp"); return; }
if (perms == null) { response.sendRedirect("accessDenied.jsp"); return; }
int roleId = user.getRoleId();
String roleName = roleId == 1 ? "Admin" : (roleId == 2 ? "Manager" : "Employee");
String roleClass = roleName.toLowerCase();
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
            <h1>&#x1F465; User Management</h1>
            <div class="nav-links">
                <a href="dashboard.jsp" class="btn btn-ghost btn-sm">&#x2190; Dashboard</a>
            </div>
        </div>

        <div class="content-grid">

            <!-- Add User -->
            <% if (perms.contains("CREATE_USER")) { %>
            <div class="card">
                <div class="card-header">
                    <h3><span class="card-icon green">&#x2795;</span> Add New User</h3>
                </div>
                <form action="addUser" method="post">
                    <div class="form-group">
                        <label for="name">Full Name</label>
                        <input type="text" id="name" name="name" placeholder="Enter full name" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" placeholder="Enter email" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" placeholder="Enter password" required>
                    </div>
                    <div class="form-group">
                        <label for="roleId">Assign Role</label>
                        <select id="roleId" name="roleId">
                            <%
                            try {
                                Connection con = DBConnection.getConnection();
                                Statement stmt = con.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT * FROM roles");
                                while (rs.next()) {
                            %>
                                <option value="<%= rs.getInt("id") %>"><%= rs.getString("name") %></option>
                            <%
                                }
                                con.close();
                            } catch (Exception e) { e.printStackTrace(); }
                            %>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-success w-full">&#x2795; Add User</button>
                </form>
            </div>
            <% } %>

            <!-- Delete User -->
            <% if (perms.contains("DELETE_USER")) { %>
            <div class="card">
                <div class="card-header">
                    <h3><span class="card-icon red">&#x1F5D1;</span> Remove User</h3>
                </div>
                <form action="deleteUser" method="post">
                    <div class="form-group">
                        <label for="userId">Select User to Remove</label>
                        <select id="userId" name="userId" required>
                            <option value="">Select User</option>
                            <%
                            try {
                                Connection con = DBConnection.getConnection();
                                PreparedStatement ps = con.prepareStatement("SELECT id, name, email FROM users WHERE id != ?");
                                ps.setInt(1, user.getId());
                                ResultSet rs = ps.executeQuery();
                                while (rs.next()) {
                            %>
                                <option value="<%= rs.getInt("id") %>"><%= rs.getString("name") %> (<%= rs.getString("email") %>)</option>
                            <%
                                }
                                con.close();
                            } catch (Exception e) { e.printStackTrace(); }
                            %>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-danger w-full" onclick="return confirm('Are you sure you want to delete this user?');">
                        &#x1F5D1; Delete User
                    </button>
                </form>
            </div>
            <% } %>

        </div>

        <!-- User List -->
        <div class="card mt-3">
            <div class="card-header">
                <h3><span class="card-icon blue">&#x1F4CB;</span> All Users</h3>
            </div>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Role</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    try {
                        Connection con = DBConnection.getConnection();
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery(
                            "SELECT u.id, u.name, u.email, r.name AS role_name FROM users u JOIN roles r ON u.role_id = r.id ORDER BY u.id"
                        );
                        while (rs.next()) {
                            String rn = rs.getString("role_name");
                            String rc = "Admin".equals(rn) ? "admin" : ("Manager".equals(rn) ? "manager" : "employee");
                    %>
                        <tr>
                            <td><%= rs.getInt("id") %></td>
                            <td><strong><%= rs.getString("name") %></strong></td>
                            <td><%= rs.getString("email") %></td>
                            <td><span class="role-badge <%= rc %>"><%= rn %></span></td>
                        </tr>
                    <%
                        }
                        con.close();
                    } catch (Exception e) { e.printStackTrace(); }
                    %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>

</body>
</html>