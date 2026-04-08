<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="model.*" %>
<%@ page import="dao.TaskDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IWAS — My Insights</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<%
User user = (User) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }

List<Task> overdueTasks = (List<Task>) request.getAttribute("overdueTasks");
List<EmployeeStat> allStats = (List<EmployeeStat>) request.getAttribute("allStats");
List<Map<String, String>> recommendations = (List<Map<String, String>>) request.getAttribute("recommendations");

// Find this employee's stats
EmployeeStat myStat = null;
if (allStats != null) {
    for (EmployeeStat s : allStats) {
        if (s.getEmployeeId() == user.getId()) {
            myStat = s;
            break;
        }
    }
}

// Get personal overdue tasks
TaskDAO taskDAO = new TaskDAO();
List<Task> myTasks = taskDAO.getTasksByEmployee(user.getId());
int myOverdue = 0;
for (Task t : myTasks) {
    if ("overdue".equals(t.getStatus())) myOverdue++;
}
%>

<div class="page-wrapper">

    <nav class="navbar">
        <div class="navbar-brand">
            <div class="brand-icon">&#x1F916;</div>
            IWAS
        </div>
        <div class="navbar-right">
            <span class="role-badge employee">Employee</span>
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
            <h1>&#x1F9E0; My Performance Insights</h1>
            <div class="nav-links">
                <a href="dashboard.jsp" class="btn btn-ghost btn-sm">&#x2190; Dashboard</a>
                <a href="tasks" class="btn btn-primary btn-sm">&#x1F4DD; My Tasks</a>
            </div>
        </div>

        <!-- Personal Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value"><%= myStat != null ? myStat.getActiveTasks() : 0 %></div>
                <div class="stat-label">Active Tasks</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= myStat != null ? myStat.getTasksCompleted() : 0 %></div>
                <div class="stat-label">Completed</div>
            </div>
            <div class="stat-card">
                <div class="stat-value" style="<%= myStat != null && myStat.getTasksDelayed() > 0 ? "-webkit-text-fill-color: #ef4444;" : "" %>">
                    <%= myStat != null ? myStat.getTasksDelayed() : 0 %>
                </div>
                <div class="stat-label">Delayed</div>
            </div>
            <div class="stat-card">
                <div class="stat-value" style="<%= myOverdue > 0 ? "-webkit-text-fill-color: #ef4444;" : "" %>"><%= myOverdue %></div>
                <div class="stat-label">Overdue</div>
            </div>
        </div>

        <div class="content-grid">

            <!-- Personal Alerts -->
            <div class="insights-panel" style="grid-column: 1 / -1;">
                <div class="insight-header">
                    <span style="font-size: 1.3rem;">&#x1F514;</span>
                    <h3>Personal Alerts & Notifications</h3>
                </div>

                <% if (myOverdue > 0) { %>
                    <div class="alert-item critical">
                        <div class="alert-icon">&#x1F6A8;</div>
                        <div class="alert-content">
                            <div class="alert-type">Overdue Alert</div>
                            <div class="alert-message">You have <%= myOverdue %> overdue task(s). Please review and update their status immediately.</div>
                        </div>
                    </div>
                <% } %>

                <% if (myStat != null && myStat.isOverloaded()) { %>
                    <div class="alert-item warning">
                        <div class="alert-icon">&#x26A0;</div>
                        <div class="alert-content">
                            <div class="alert-type">Workload Warning</div>
                            <div class="alert-message">You currently have <%= myStat.getActiveTasks() %> active tasks. You may be overloaded — consider discussing priorities with your manager.</div>
                        </div>
                    </div>
                <% } %>

                <% if (myStat != null && myStat.isHighRisk()) { %>
                    <div class="alert-item warning">
                        <div class="alert-icon">&#x26A0;</div>
                        <div class="alert-content">
                            <div class="alert-type">Performance Alert</div>
                            <div class="alert-message">Your delay rate is at <%= String.format("%.0f", myStat.getRiskScore()) %>%%. Try to complete tasks before their deadlines to improve your score.</div>
                        </div>
                    </div>
                <% } %>

                <% if (myOverdue == 0 && (myStat == null || (!myStat.isOverloaded() && !myStat.isHighRisk()))) { %>
                    <div class="alert-item info">
                        <div class="alert-icon">&#x2705;</div>
                        <div class="alert-content">
                            <div class="alert-type">All Clear</div>
                            <div class="alert-message">Great work! You have no alerts at this time. Keep up the good pace!</div>
                        </div>
                    </div>
                <% } %>
            </div>

        </div>
    </div>
</div>

</body>
</html>
