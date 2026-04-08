package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.UserDAO;
import model.User;

@WebServlet("/addUser")
public class AddUserServlet extends HttpServlet {
	  private static final long serialVersionUID = 1L;
	  @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<String> perms = (List<String>) session.getAttribute("permissions");

        // 🔒 RBAC check
        if (perms == null || !perms.contains("CREATE_USER")) {
            response.sendRedirect("accessDenied.jsp");
            return;
        }

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        int roleId = Integer.parseInt(request.getParameter("roleId"));

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);
        user.setRoleId(roleId);

        UserDAO dao = new UserDAO();
        dao.addUser(user);

        response.sendRedirect("manageUsers.jsp");
    }
}