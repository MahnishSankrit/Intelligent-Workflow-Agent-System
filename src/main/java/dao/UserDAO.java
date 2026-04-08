package dao;

import java.sql.*;
import model.User;
import util.DBConnection;

public class UserDAO {

    // 🔐 LOGIN
    public User login(String email, String password) {
        User user = null;

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE email=? AND password=?"
            );

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setRoleId(rs.getInt("role_id"));
            }
            System.out.println("Email from form: " + email);
            System.out.println("Password from form: " + password);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    // ➕ ADD USER
    public void addUser(User user) {
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO users(name,email,password,role_id) VALUES(?,?,?,?)"
            );

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setInt(4, user.getRoleId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ❌ DELETE USER
    public void deleteUser(int userId) {
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM users WHERE id=?"
            );

            ps.setInt(1, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}