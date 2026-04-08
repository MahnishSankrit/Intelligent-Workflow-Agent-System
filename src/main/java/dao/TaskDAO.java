package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Task;
import util.DBConnection;

public class TaskDAO {

    // =====================
    // Get tasks assigned to a specific employee
    // =====================
    public List<Task> getTasksByEmployee(int employeeId) {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT t.*, " +
                     "u1.name AS assigned_to_name, " +
                     "u2.name AS assigned_by_name " +
                     "FROM tasks t " +
                     "LEFT JOIN users u1 ON t.assigned_to = u1.id " +
                     "LEFT JOIN users u2 ON t.assigned_by = u2.id " +
                     "WHERE t.assigned_to = ? " +
                     "ORDER BY t.deadline ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapTask(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =====================
    // Get tasks assigned by a specific manager
    // =====================
    public List<Task> getTasksByManager(int managerId) {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT t.*, " +
                     "u1.name AS assigned_to_name, " +
                     "u2.name AS assigned_by_name " +
                     "FROM tasks t " +
                     "LEFT JOIN users u1 ON t.assigned_to = u1.id " +
                     "LEFT JOIN users u2 ON t.assigned_by = u2.id " +
                     "WHERE t.assigned_by = ? " +
                     "ORDER BY t.deadline ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapTask(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =====================
    // Get ALL tasks (for Admin)
    // =====================
    public List<Task> getAllTasks() {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT t.*, " +
                     "u1.name AS assigned_to_name, " +
                     "u2.name AS assigned_by_name " +
                     "FROM tasks t " +
                     "LEFT JOIN users u1 ON t.assigned_to = u1.id " +
                     "LEFT JOIN users u2 ON t.assigned_by = u2.id " +
                     "ORDER BY t.deadline ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapTask(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =====================
    // Create a new task
    // =====================
    public void createTask(Task task) {
        String sql = "INSERT INTO tasks (title, description, assigned_to, assigned_by, status, priority, deadline) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, task.getTitle());
            ps.setString(2, task.getDescription());
            ps.setInt(3, task.getAssignedTo());
            ps.setInt(4, task.getAssignedBy());
            ps.setString(5, task.getStatus());
            ps.setString(6, task.getPriority());
            ps.setDate(7, task.getDeadline());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =====================
    // Update task status (with audit log)
    // =====================
    public void updateTaskStatus(int taskId, String newStatus) {
        String selectSql = "SELECT status FROM tasks WHERE id = ?";
        String updateSql = "UPDATE tasks SET status = ? WHERE id = ?";
        String logSql = "INSERT INTO task_logs (task_id, old_status, new_status) VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection()) {
            // Get old status
            String oldStatus = null;
            try (PreparedStatement ps = con.prepareStatement(selectSql)) {
                ps.setInt(1, taskId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    oldStatus = rs.getString("status");
                }
            }

            // Update
            try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                ps.setString(1, newStatus);
                ps.setInt(2, taskId);
                ps.executeUpdate();
            }

            // Log
            try (PreparedStatement ps = con.prepareStatement(logSql)) {
                ps.setInt(1, taskId);
                ps.setString(2, oldStatus);
                ps.setString(3, newStatus);
                ps.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =====================
    // Get overdue tasks (deadline < today AND status NOT completed)
    // =====================
    public List<Task> getOverdueTasks() {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT t.*, " +
                     "u1.name AS assigned_to_name, " +
                     "u2.name AS assigned_by_name " +
                     "FROM tasks t " +
                     "LEFT JOIN users u1 ON t.assigned_to = u1.id " +
                     "LEFT JOIN users u2 ON t.assigned_by = u2.id " +
                     "WHERE t.deadline < CURDATE() AND t.status NOT IN ('completed', 'overdue') " +
                     "ORDER BY t.deadline ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapTask(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =====================
    // Mark overdue tasks automatically
    // =====================
    public int markOverdueTasks() {
        String sql = "UPDATE tasks SET status = 'overdue' " +
                     "WHERE deadline < CURDATE() AND status NOT IN ('completed', 'overdue')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // =====================
    // Count active tasks per employee
    // =====================
    public int countActiveTasks(int employeeId) {
        String sql = "SELECT COUNT(*) FROM tasks WHERE assigned_to = ? AND status IN ('pending', 'in_progress')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // =====================
    // Get a single task by ID
    // =====================
    public Task getTaskById(int taskId) {
        String sql = "SELECT t.*, " +
                     "u1.name AS assigned_to_name, " +
                     "u2.name AS assigned_by_name " +
                     "FROM tasks t " +
                     "LEFT JOIN users u1 ON t.assigned_to = u1.id " +
                     "LEFT JOIN users u2 ON t.assigned_by = u2.id " +
                     "WHERE t.id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapTask(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // =====================
    // Helper: map ResultSet row to Task
    // =====================
    private Task mapTask(ResultSet rs) throws SQLException {
        Task t = new Task();
        t.setId(rs.getInt("id"));
        t.setTitle(rs.getString("title"));
        t.setDescription(rs.getString("description"));
        t.setAssignedTo(rs.getInt("assigned_to"));
        t.setAssignedBy(rs.getInt("assigned_by"));
        t.setStatus(rs.getString("status"));
        t.setPriority(rs.getString("priority"));
        t.setDeadline(rs.getDate("deadline"));
        t.setCreatedAt(rs.getTimestamp("created_at"));
        t.setAssignedToName(rs.getString("assigned_to_name"));
        t.setAssignedByName(rs.getString("assigned_by_name"));
        return t;
    }
}
