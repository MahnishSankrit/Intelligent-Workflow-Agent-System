<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="model.Task" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IWAS — Tasks</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<%
User user = (User) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }
List<String> perms = (List<String>) session.getAttribute("permissions");
int roleId = user.getRoleId();
String roleName = roleId == 1 ? "Admin" : (roleId == 2 ? "Manager" : "Employee");
String roleClass = roleName.toLowerCase();

List<Task> tasks = (List<Task>) request.getAttribute("tasks");
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
            <h1>&#x1F4DD; Task Management</h1>
            <div class="nav-links">
                <a href="dashboard.jsp" class="btn btn-ghost btn-sm">&#x2190; Dashboard</a>
                <a href="agent" class="btn btn-info btn-sm">&#x1F9E0; Agent Insights</a>
            </div>
        </div>

        <div class="content-grid">

            <!-- ========== CREATE TASK (Manager / Admin) ========== -->
            <% if (roleId <= 2) { %>
            <div class="card">
                <div class="card-header">
                    <h3><span class="card-icon green">&#x2795;</span> Create New Task</h3>
                </div>
                <form action="tasks" method="post">
                    <input type="hidden" name="action" value="create">

                    <div class="form-group">
                        <label for="title">Task Title</label>
                        <input type="text" id="title" name="title" placeholder="Enter task title" required>
                    </div>

                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" placeholder="Describe the task..."></textarea>
                    </div>

                    <div class="form-group">
                        <label for="assignedTo">Assign To</label>
                        <select id="assignedTo" name="assignedTo" required>
                            <option value="">Select Employee</option>
                            <%
                            try {
                                Connection con = DBConnection.getConnection();
                                PreparedStatement ps = con.prepareStatement("SELECT id, name FROM users WHERE role_id = 3");
                                ResultSet rs = ps.executeQuery();
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

                    <div class="form-group">
                        <label for="priority">Priority</label>
                        <select id="priority" name="priority">
                            <option value="low">Low</option>
                            <option value="medium" selected>Medium</option>
                            <option value="high">High</option>
                            <option value="critical">Critical</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="deadline">Deadline</label>
                        <input type="date" id="deadline" name="deadline" required>
                    </div>

                    <button type="submit" class="btn btn-success w-full">&#x1F4E4; Create Task</button>
                </form>
            </div>
            <% } %>

            <!-- ========== TASK LIST ========== -->
            <div class="card" style="<%= roleId <= 2 ? "" : "grid-column: 1 / -1;" %>">
                <div class="card-header">
                    <h3><span class="card-icon blue">&#x1F4CB;</span>
                        <%= roleId == 3 ? "My Tasks" : (roleId == 2 ? "Tasks I Assigned" : "All Tasks") %>
                    </h3>
                    <span class="status-badge completed"><%= tasks != null ? tasks.size() : 0 %> total</span>
                </div>

                <% if (tasks != null && !tasks.isEmpty()) { %>
                <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th>Title</th>
                                <% if (roleId != 3) { %><th>Assigned To</th><% } %>
                                <th>Priority</th>
                                <th>Deadline</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                        for (Task t : tasks) {
                            String statusClass = t.getStatus().replace("_", "-");
                        %>
                            <tr>
                                <td>
                                    <strong><%= t.getTitle() %></strong>
                                    <% if (t.getDescription() != null && !t.getDescription().isEmpty()) { %>
                                        <br><small style="color: var(--text-muted);"><%= t.getDescription().length() > 50 ? t.getDescription().substring(0, 50) + "..." : t.getDescription() %></small>
                                    <% } %>
                                </td>
                                <% if (roleId != 3) { %>
                                    <td><%= t.getAssignedToName() != null ? t.getAssignedToName() : "Unassigned" %></td>
                                <% } %>
                                <td><span class="priority-badge <%= t.getPriority() %>"><%= t.getPriority() %></span></td>
                                <td><%= t.getDeadline() %></td>
                                <td><span class="status-badge <%= statusClass %>"><%= t.getStatus() %></span></td>
                                <td>
                                    <% if (!"completed".equals(t.getStatus())) { %>
                                    <form action="tasks" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="taskId" value="<%= t.getId() %>">
                                        <% if ("pending".equals(t.getStatus()) || "overdue".equals(t.getStatus())) { %>
                                            <input type="hidden" name="newStatus" value="in_progress">
                                            <button type="submit" class="btn btn-info btn-sm">&#x25B6; Start</button>
                                        <% } else if ("in_progress".equals(t.getStatus())) { %>
                                            <input type="hidden" name="newStatus" value="completed">
                                            <button type="submit" class="btn btn-success btn-sm">&#x2714; Complete</button>
                                        <% } %>
                                    </form>
                                    <% } else { %>
                                        <span style="color: var(--status-success); font-size: 0.85rem;">&#x2714; Done</span>
                                    <% } %>
                                </td>
                            </tr>
                        <%
                        }
                        %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                    <div class="text-center mt-2" style="color: var(--text-muted); padding: 40px 0;">
                        &#x1F4ED; No tasks found.
                    </div>
                <% } %>
            </div>

        </div>
    </div>
</div>

</body>
</html>
