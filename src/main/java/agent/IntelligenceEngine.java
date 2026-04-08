package agent;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dao.EmployeeStatDAO;
import dao.TaskDAO;
import model.EmployeeStat;
import model.Task;

/**
 * IntelligenceEngine — The centralized "brain" of the IWAS agent system.
 *
 * Combines the logic of:
 *   - Monitoring Agent   : detects overdue tasks
 *   - Workload Agent     : detects overloaded employees
 *   - Productivity Agent : evaluates employee risk scores
 *   - Recommendation Agent : suggests reassignment / priority changes
 *   - Notification Agent : aggregates all alerts for the UI
 *
 * This runs on-demand whenever dashboards are loaded, providing
 * reactive real-time intelligence without background threads.
 */
public class IntelligenceEngine {

    private final TaskDAO taskDAO = new TaskDAO();
    private final EmployeeStatDAO statDAO = new EmployeeStatDAO();

    // =============================================
    // MONITORING AGENT — overdue detection & marking
    // =============================================

    /**
     * Scans for overdue tasks and marks them.
     * Returns the number of tasks newly marked as overdue.
     */
    public int runOverdueCheck() {
        return taskDAO.markOverdueTasks();
    }

    /**
     * Returns list of currently overdue tasks.
     */
    public List<Task> getOverdueTasks() {
        return taskDAO.getOverdueTasks();
    }

    // =============================================
    // WORKLOAD AGENT — employee load analysis
    // =============================================

    /**
     * Returns list of employees flagged as overloaded (>5 active tasks).
     */
    public List<EmployeeStat> getOverloadedEmployees() {
        List<EmployeeStat> all = statDAO.getAllStats();
        List<EmployeeStat> overloaded = new ArrayList<>();
        for (EmployeeStat stat : all) {
            if (stat.isOverloaded()) {
                overloaded.add(stat);
            }
        }
        return overloaded;
    }

    // =============================================
    // PRODUCTIVITY AGENT — risk analysis
    // =============================================

    /**
     * Returns employees with high risk scores (>40% delay rate).
     */
    public List<EmployeeStat> getHighRiskEmployees() {
        List<EmployeeStat> all = statDAO.getAllStats();
        List<EmployeeStat> risky = new ArrayList<>();
        for (EmployeeStat stat : all) {
            if (stat.isHighRisk()) {
                risky.add(stat);
            }
        }
        return risky;
    }

    // =============================================
    // RECOMMENDATION AGENT — smart suggestions
    // =============================================

    /**
     * Generates actionable suggestions based on current system state.
     * Each suggestion is a Map with keys:
     *   - "type"     : "reassignment" | "priority" | "workload"
     *   - "severity" : "info" | "warning" | "critical"
     *   - "message"  : human-readable recommendation
     */
    public List<Map<String, String>> getRecommendations() {
        List<Map<String, String>> suggestions = new ArrayList<>();

        // Check overloaded employees and suggest reassignment
        List<EmployeeStat> allStats = statDAO.getAllStats();
        EmployeeStat leastLoaded = null;

        for (EmployeeStat stat : allStats) {
            if (leastLoaded == null || stat.getActiveTasks() < leastLoaded.getActiveTasks()) {
                leastLoaded = stat;
            }
        }

        for (EmployeeStat stat : allStats) {
            if (stat.isOverloaded() && leastLoaded != null
                    && leastLoaded.getEmployeeId() != stat.getEmployeeId()) {
                Map<String, String> s = new HashMap<>();
                s.put("type", "reassignment");
                s.put("severity", "warning");
                s.put("message", "Consider reassigning tasks from " +
                        stat.getEmployeeName() + " (" + stat.getActiveTasks() + " active) to " +
                        leastLoaded.getEmployeeName() + " (" + leastLoaded.getActiveTasks() + " active).");
                suggestions.add(s);
            }

            if (stat.isHighRisk()) {
                Map<String, String> s = new HashMap<>();
                s.put("type", "priority");
                s.put("severity", "critical");
                s.put("message", stat.getEmployeeName() +
                        " has a high delay rate (" + String.format("%.0f", stat.getRiskScore()) +
                        "%). Review their task assignments and deadlines.");
                suggestions.add(s);
            }
        }

        // Overdue task alerts
        List<Task> overdue = taskDAO.getOverdueTasks();
        for (Task t : overdue) {
            Map<String, String> s = new HashMap<>();
            s.put("type", "overdue");
            s.put("severity", "critical");
            s.put("message", "Task \"" + t.getTitle() + "\" assigned to " +
                    t.getAssignedToName() + " is past its deadline (" + t.getDeadline() + ").");
            suggestions.add(s);
        }

        if (suggestions.isEmpty()) {
            Map<String, String> s = new HashMap<>();
            s.put("type", "info");
            s.put("severity", "info");
            s.put("message", "All systems operational. No alerts at this time.");
            suggestions.add(s);
        }

        return suggestions;
    }

    // =============================================
    // NOTIFICATION AGENT — full dashboard payload
    // =============================================

    /**
     * Generates a complete intelligence report for the dashboard.
     * Returns a Map containing:
     *  - "overdueTasks"         : List<Task>
     *  - "overloadedEmployees"  : List<EmployeeStat>
     *  - "highRiskEmployees"    : List<EmployeeStat>
     *  - "recommendations"      : List<Map<String,String>>
     *  - "allStats"             : List<EmployeeStat>
     *  - "overdueCount"         : int (newly marked)
     */
    public Map<String, Object> generateFullReport() {
        Map<String, Object> report = new HashMap<>();

        // Run monitoring agent first — mark overdue tasks
        int newlyOverdue = runOverdueCheck();
        report.put("overdueCount", newlyOverdue);

        // Gather intelligence
        report.put("overdueTasks", getOverdueTasks());
        report.put("overloadedEmployees", getOverloadedEmployees());
        report.put("highRiskEmployees", getHighRiskEmployees());
        report.put("recommendations", getRecommendations());
        report.put("allStats", statDAO.getAllStats());

        return report;
    }
}
