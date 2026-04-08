package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import util.DBConnection;

@WebServlet("/assignPermission")
public class AssignPermissionServlet extends HttpServlet {
	  private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int roleId = Integer.parseInt(request.getParameter("roleId"));
        String[] permissions = request.getParameterValues("permissions");

        try {
            Connection con = DBConnection.getConnection();

            // Remove old permissions
            PreparedStatement delete = con.prepareStatement(
                "DELETE FROM role_permissions WHERE role_id=?"
            );
            delete.setInt(1, roleId);
            delete.executeUpdate();

            // Insert new permissions
            if (permissions != null) {
                for (String pid : permissions) {
                    PreparedStatement insert = con.prepareStatement(
                        "INSERT INTO role_permissions(role_id, permission_id) VALUES (?,?)"
                    );
                    insert.setInt(1, roleId);
                    insert.setInt(2, Integer.parseInt(pid));
                    insert.executeUpdate();
                }
            }

            response.sendRedirect("manageRoles.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}