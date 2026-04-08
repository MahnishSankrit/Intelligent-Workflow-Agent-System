<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<html>
<link rel="stylesheet" href="css/style.css">
<body>

<h2>System Report</h2>

<%
Connection con = DBConnection.getConnection();
Statement stmt = con.createStatement();

// Total Users
ResultSet rs1 = stmt.executeQuery("SELECT COUNT(*) FROM users");
rs1.next();
int totalUsers = rs1.getInt(1);

// Total Roles
ResultSet rs2 = stmt.executeQuery("SELECT COUNT(*) FROM roles");
rs2.next();
int totalRoles = rs2.getInt(1);

// Total Permissions
ResultSet rs3 = stmt.executeQuery("SELECT COUNT(*) FROM permissions");
rs3.next();
int totalPermissions = rs3.getInt(1);
%>

<p>Total Users: <%= totalUsers %></p>
<p>Total Roles: <%= totalRoles %></p>
<p>Total Permissions: <%= totalPermissions %></p>

</body>
</html>