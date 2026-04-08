package controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import agent.IntelligenceEngine;
import model.EmployeeStat;
import model.Task;
import model.User;

@WebServlet("/agent")
public class AgentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final IntelligenceEngine engine = new IntelligenceEngine();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Run the full intelligence report
        Map<String, Object> report = engine.generateFullReport();

        // Set attributes for JSP rendering
        request.setAttribute("overdueTasks", report.get("overdueTasks"));
        request.setAttribute("overloadedEmployees", report.get("overloadedEmployees"));
        request.setAttribute("highRiskEmployees", report.get("highRiskEmployees"));
        request.setAttribute("recommendations", report.get("recommendations"));
        request.setAttribute("allStats", report.get("allStats"));
        request.setAttribute("overdueCount", report.get("overdueCount"));

        // Route based on role
        int roleId = user.getRoleId();
        if (roleId == 1) {
            request.getRequestDispatcher("adminInsights.jsp").forward(request, response);
        } else if (roleId == 2) {
            request.getRequestDispatcher("managerInsights.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("employeeInsights.jsp").forward(request, response);
        }
    }
}
