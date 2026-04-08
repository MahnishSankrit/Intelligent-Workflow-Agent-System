<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="model.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IWAS — Admin Intelligence</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<%
User user = (User) session.getAttribute("user");
if (user == null) { response.sendRedirect("login.jsp"); return; }

List<Task> overdueTasks = (List<Task>) request.getAttribute("overdueTasks");
List<EmployeeStat> overloadedEmployees = (List<EmployeeStat>) request.getAttribute("overloadedEmployees");
List<EmployeeStat> highRiskEmployees = (List<EmployeeStat>) request.getAttribute("highRiskEmployees");
List<Map<String, String>> recommendations = (List<Map<String, String>>) request.getAttribute("recommendations");
List<EmployeeStat> allStats = (List<EmployeeStat>) request.getAttribute("allStats");
Integer overdueCount = (Integer) request.getAttribute("overdueCount");
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
            <h1>&#x1F9E0; Agent Intelligence Center</h1>
            <div class="nav-links">
                <a href="dashboard.jsp" class="btn btn-ghost btn-sm">&#x2190; Dashboard</a>
                <a href="tasks" class="btn btn-primary btn-sm">&#x1F4DD; Tasks</a>
            </div>
        </div>

        <!-- Alert Summary Stats -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value" style="<%= overdueCount != null && overdueCount > 0 ? "-webkit-text-fill-color: #ef4444;" : "" %>">
                    <%= overdueTasks != null ? overdueTasks.size() : 0 %>
                </div>
                <div class="stat-label">Overdue Tasks</div>
            </div>
            <div class="stat-card">
                <div class="stat-value" style="<%= overloadedEmployees != null && !overloadedEmployees.isEmpty() ? "-webkit-text-fill-color: #f59e0b;" : "" %>">
                    <%= overloadedEmployees != null ? overloadedEmployees.size() : 0 %>
                </div>
                <div class="stat-label">Overloaded Employees</div>
            </div>
            <div class="stat-card">
                <div class="stat-value" style="<%= highRiskEmployees != null && !highRiskEmployees.isEmpty() ? "-webkit-text-fill-color: #ef4444;" : "" %>">
                    <%= highRiskEmployees != null ? highRiskEmployees.size() : 0 %>
                </div>
                <div class="stat-label">High-Risk Employees</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= recommendations != null ? recommendations.size() : 0 %></div>
                <div class="stat-label">Active Recommendations</div>
            </div>
        </div>

        <div class="content-grid">

            <!-- Recommendations Panel -->
            <div class="insights-panel" style="grid-column: 1 / -1;">
                <div class="insight-header">
                    <span style="font-size: 1.3rem;">&#x1F4A1;</span>
                    <h3>AI Recommendations & System Alerts</h3>
                </div>
                <%
                if (recommendations != null) {
                    for (Map<String, String> rec : recommendations) {
                        String severity = rec.get("severity");
                        String type = rec.get("type");
                        String message = rec.get("message");
                        String icon = "critical".equals(severity) ? "&#x1F6A8;" : ("warning".equals(severity) ? "&#x26A0;" : "&#x2139;");
                %>
                    <div class="alert-item <%= severity %>">
                        <div class="alert-icon"><%= icon %></div>
                        <div class="alert-content">
                            <div class="alert-type"><%= type %></div>
                            <div class="alert-message"><%= message %></div>
                        </div>
                    </div>
                <%
                    }
                }
                %>
            </div>

            <!-- Employee Productivity Table -->
            <div class="card" style="grid-column: 1 / -1;">
                <div class="card-header">
                    <h3><span class="card-icon blue">&#x1F4CA;</span> Employee Productivity Overview</h3>
                </div>
                <% if (allStats != null && !allStats.isEmpty()) { %>
                <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th>Employee</th>
                                <th>Active Tasks</th>
                                <th>Completed</th>
                                <th>Delayed</th>
                                <th>Risk Score</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                        for (EmployeeStat stat : allStats) {
                        %>
                            <tr>
                                <td><strong><%= stat.getEmployeeName() %></strong></td>
                                <td><%= stat.getActiveTasks() %></td>
                                <td style="color: var(--status-success);"><%= stat.getTasksCompleted() %></td>
                                <td style="color: var(--status-danger);"><%= stat.getTasksDelayed() %></td>
                                <td>
                                    <span class="priority-badge <%= stat.getRiskScore() > 40 ? "critical" : (stat.getRiskScore() > 20 ? "high" : "low") %>">
                                        <%= String.format("%.0f", stat.getRiskScore()) %>%%
                                    </span>
                                </td>
                                <td>
                                    <% if (stat.isOverloaded()) { %>
                                        <span class="status-badge overdue">Overloaded</span>
                                    <% } else if (stat.isHighRisk()) { %>
                                        <span class="status-badge overdue">High Risk</span>
                                    <% } else { %>
                                        <span class="status-badge completed">Normal</span>
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
                        No employee statistics available.
                    </div>
                <% } %>
            </div>

        </div>
    </div>
</div>

</body>
</html>
