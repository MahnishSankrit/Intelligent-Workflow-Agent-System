package model;

public class EmployeeStat {

    private int employeeId;
    private String employeeName;
    private int tasksCompleted;
    private int tasksDelayed;
    private int activeTasks;    // transient — computed at runtime

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    public int getTasksCompleted() { return tasksCompleted; }
    public void setTasksCompleted(int tasksCompleted) { this.tasksCompleted = tasksCompleted; }

    public int getTasksDelayed() { return tasksDelayed; }
    public void setTasksDelayed(int tasksDelayed) { this.tasksDelayed = tasksDelayed; }

    public int getActiveTasks() { return activeTasks; }
    public void setActiveTasks(int activeTasks) { this.activeTasks = activeTasks; }

    /** Returns a risk score — higher means more problematic */
    public double getRiskScore() {
        int total = tasksCompleted + tasksDelayed;
        if (total == 0) return 0;
        return (double) tasksDelayed / total * 100;
    }

    public boolean isOverloaded() {
        return activeTasks > 5;
    }

    public boolean isHighRisk() {
        return getRiskScore() > 40;
    }
}
