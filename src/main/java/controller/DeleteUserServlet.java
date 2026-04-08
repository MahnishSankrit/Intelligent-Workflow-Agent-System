package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.UserDAO;

@WebServlet("/deleteUser")
public class DeleteUserServlet extends HttpServlet {
	  private static final long serialVersionUID = 1L;
	  @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<String> perms = (List<String>) session.getAttribute("permissions");

        // 🔒 RBAC check
        if (perms == null || !perms.contains("DELETE_USER")) {
            response.sendRedirect("accessDenied.jsp");
            return;
        }

        int userId = Integer.parseInt(request.getParameter("userId"));

        UserDAO dao = new UserDAO();
        dao.deleteUser(userId);

        response.sendRedirect("manageUsers.jsp");
    }
}