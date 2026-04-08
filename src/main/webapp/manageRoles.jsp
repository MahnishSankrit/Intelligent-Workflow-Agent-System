<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="model.User" %>

<html>
<head>
    <title>Manage Roles</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<%
User user = (User) session.getAttribute("user");

// 🔒 Admin check FIRST
if (user == null || user.getRoleId() != 1) {
    response.sendRedirect("accessDenied.jsp");
    return;
}
%>

<h2>Role Management</h2>

<form action="assignPermission" method="post">

<!-- Select Role -->
<label>Select Role:</label>
<select name="roleId">

<%
Connection con = DBConnection.getConnection();

// Separate statement for roles
Statement roleStmt = con.createStatement();
ResultSet rs = roleStmt.executeQuery("SELECT * FROM roles");

while (rs.next()) {
%>
    <option value="<%= rs.getInt("id") %>">
        <%= rs.getString("name") %>
    </option>
<%
}
%>

</select>

<br><br>

<!-- Permissions -->
<label>Select Permissions:</label><br>

<%
Statement permStmt = con.createStatement();
ResultSet prs = permStmt.executeQuery("SELECT * FROM permissions");

while (prs.next()) {
%>
    <input type="checkbox" name="permissions" value="<%= prs.getInt("id") %>">
    <%= prs.getString("name") %><br>
<%
}
%>

<br><br>

<button type="submit">Assign Permissions</button>

</form>

</body>
</html>