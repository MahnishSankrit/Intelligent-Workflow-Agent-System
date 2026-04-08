package dao;

import java.sql.*;
import java.util.*;
import util.DBConnection;

public class PermissionDAO {

    public List<String> getPermissionsByRole(int roleId) {
        List<String> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT p.name FROM permissions p " +
                "JOIN role_permissions rp ON p.id = rp.permission_id " +
                "WHERE rp.role_id=?"
            );

            ps.setInt(1, roleId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(rs.getString("name"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}