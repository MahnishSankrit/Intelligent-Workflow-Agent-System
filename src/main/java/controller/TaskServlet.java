package controller;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.TaskDAO;
import dao.EmployeeStatDAO;
import model.Task;
import model.User;

@WebServlet("/tasks")
public class TaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final TaskDAO taskDAO = new TaskDAO();
    private final EmployeeStatDAO statDAO = new EmployeeStatDAO();

    // ========================================
    // GET — load tasks page based on role
    // ========================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int roleId = user.getRoleId();

        List<Task> tasks;

        if (roleId == 1) {
            // Admin sees all tasks
            tasks = taskDAO.getAllTasks();
        } else if (roleId == 2) {
            // Manager sees tasks they assigned
            tasks = taskDAO.getTasksByManager(user.getId());
        } else {
            // Employee sees tasks assigned to them
            tasks = taskDAO.getTasksByEmployee(user.getId());
        }

        request.setAttribute("tasks", tasks);
        request.getRequestDispatcher("tasks.jsp").forward(request, response);
    }

    // ========================================
    // POST — create / update tasks
    // ========================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            // Only Manager (2) and Admin (1) can create
            if (user.getRoleId() > 2) {
                response.sendRedirect("accessDenied.jsp");
                return;
            }

            Task task = new Task();
            task.setTitle(request.getParameter("title"));
            task.setDescription(request.getParameter("description"));
            task.setAssignedTo(Integer.parseInt(request.getParameter("assignedTo")));
            task.setAssignedBy(user.getId());
            task.setStatus("pending");
            task.setPriority(request.getParameter("priority"));
            task.setDeadline(Date.valueOf(request.getParameter("deadline")));

            taskDAO.createTask(task);

            // Ensure employee_stats row exists for the assignee
            statDAO.ensureStatExists(task.getAssignedTo());

        } else if ("updateStatus".equals(action)) {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            String newStatus = request.getParameter("newStatus");

            // If marking as completed, update employee stats
            Task existing = taskDAO.getTaskById(taskId);
            if (existing != null && "completed".equals(newStatus) && !"completed".equals(existing.getStatus())) {
                statDAO.incrementCompleted(existing.getAssignedTo());

                // Check if the task was overdue when completed — counts as delayed
                if ("overdue".equals(existing.getStatus())) {
                    statDAO.incrementDelayed(existing.getAssignedTo());
                }
            }

            taskDAO.updateTaskStatus(taskId, newStatus);
        }

        response.sendRedirect("tasks");
    }
}
