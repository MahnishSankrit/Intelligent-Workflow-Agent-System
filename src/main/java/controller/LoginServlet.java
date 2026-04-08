package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.UserDAO;
import dao.PermissionDAO;
import model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	  private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    	String email = request.getParameter("email").trim();
    	String password = request.getParameter("password").trim();

        UserDAO dao = new UserDAO();
        User user = dao.login(email, password);
        System.out.println("Login servlet hit");
        System.out.println("User: " + user);
        if (user != null) {
            HttpSession session = request.getSession();

            // store user
            session.setAttribute("user", user);

            // fetch permissions
            PermissionDAO pdao = new PermissionDAO();
            List<String> perms = pdao.getPermissionsByRole(user.getRoleId());

            session.setAttribute("permissions", perms);

            response.sendRedirect("dashboard.jsp");
        } else {
            response.sendRedirect("login.jsp?error=1");
        }
    }
}