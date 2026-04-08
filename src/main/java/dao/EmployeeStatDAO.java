package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.EmployeeStat;
import util.DBConnection;

public class EmployeeStatDAO {

    // =====================
    // Get stats for all employees (joined with users + live active counts)
    // =====================
    public List<EmployeeStat> getAllStats() {
        List<EmployeeStat> list = new ArrayList<>();
        String sql = "SELECT es.*, u.name AS employee_name, " +
                     "(SELECT COUNT(*) FROM tasks t WHERE t.assigned_to = es.employee_id " +
                     " AND t.status IN ('pending', 'in_progress')) AS active_tasks " +
                     "FROM employee_stats es " +
                     "JOIN users u ON es.employee_id = u.id " +
                     "ORDER BY u.name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                EmployeeStat stat = new EmployeeStat();
                stat.setEmployeeId(rs.getInt("employee_id"));
                stat.setEmployeeName(rs.getString("employee_name"));
                stat.setTasksCompleted(rs.getInt("tasks_completed"));
                stat.setTasksDelayed(rs.getInt("tasks_delayed"));
                stat.setActiveTasks(rs.getInt("active_tasks"));
                list.add(stat);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =====================
    // Get stats for a single employee
    // =====================
    public EmployeeStat getStatByEmployee(int employeeId) {
        String sql = "SELECT es.*, u.name AS employee_name, " +
                     "(SELECT COUNT(*) FROM tasks t WHERE t.assigned_to = es.employee_id " +
                     " AND t.status IN ('pending', 'in_progress')) AS active_tasks " +
                     "FROM employee_stats es " +
                     "JOIN users u ON es.employee_id = u.id " +
                     "WHERE es.employee_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                EmployeeStat stat = new EmployeeStat();
                stat.setEmployeeId(rs.getInt("employee_id"));
                stat.setEmployeeName(rs.getString("employee_name"));
                stat.setTasksCompleted(rs.getInt("tasks_completed"));
                stat.setTasksDelayed(rs.getInt("tasks_delayed"));
                stat.setActiveTasks(rs.getInt("active_tasks"));
                return stat;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // =====================
    // Increment completed count
    // =====================
    public void incrementCompleted(int employeeId) {
        String sql = "UPDATE employee_stats SET tasks_completed = tasks_completed + 1 WHERE employee_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =====================
    // Increment delayed count
    // =====================
    public void incrementDelayed(int employeeId) {
        String sql = "UPDATE employee_stats SET tasks_delayed = tasks_delayed + 1 WHERE employee_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =====================
    // Ensure stat row exists for an employee
    // =====================
    public void ensureStatExists(int employeeId) {
        String sql = "INSERT IGNORE INTO employee_stats (employee_id, tasks_completed, tasks_delayed) VALUES (?, 0, 0)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
