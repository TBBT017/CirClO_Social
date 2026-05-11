package database;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    public static boolean applyToProject(int projectId, int applicantId, String message) {
        String sql = "INSERT INTO Applications (project_id, applicant_id, message) VALUES (?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            ps.setInt(2, applicantId);
            ps.setString(3, message);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            if (e.getMessage().contains("Duplicate")) {
                System.out.println("You have already applied to this project.");
            } else {
                System.out.println("applyToProject error: " + e.getMessage());
            }
            return false;
        }
    }

    // For project creator — see who applied to their project
    public static List<String> getApplicationsByProject(int projectId) {
        List<String> result = new ArrayList<>();
        String sql = "SELECT a.application_id, u.username, a.message, a.status, a.created_at " +
                     "FROM Applications a JOIN Users u ON a.applicant_id = u.user_id " +
                     "WHERE a.project_id = ? ORDER BY a.created_at ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(String.format("[AppID:%d] @%s | Status: %s\n  \"%s\"",
                            rs.getInt("application_id"), rs.getString("username"),
                            rs.getString("status"), rs.getString("message")));
                }
            }
        } catch (SQLException e) {
            System.out.println("getApplicationsByProject error: " + e.getMessage());
        }
        return result;
    }

    // For applicant — see all projects they applied to
    public static List<String> getMyApplications(int applicantId) {
        List<String> result = new ArrayList<>();
        String sql = "SELECT a.application_id, p.title, a.status, a.created_at " +
                     "FROM Applications a JOIN Projects p ON a.project_id = p.project_id " +
                     "WHERE a.applicant_id = ? ORDER BY a.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, applicantId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(String.format("[AppID:%d] \"%s\" | Status: %s | %s",
                            rs.getInt("application_id"), rs.getString("title"),
                            rs.getString("status"), rs.getTimestamp("created_at")));
                }
            }
        } catch (SQLException e) {
            System.out.println("getMyApplications error: " + e.getMessage());
        }
        return result;
    }

    // Project creator accepts or rejects an application
    public static boolean updateApplicationStatus(int applicationId, int creatorId, String status) {
        String sql = "UPDATE Applications a " +
                     "JOIN Projects p ON a.project_id = p.project_id " +
                     "SET a.status = ? " +
                     "WHERE a.application_id = ? AND p.creator_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, applicationId);
            ps.setInt(3, creatorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("updateApplicationStatus error: " + e.getMessage());
            return false;
        }
    }

    // Applicant withdraws their own application
    public static boolean withdrawApplication(int applicationId, int applicantId) {
        String sql = "DELETE FROM Applications WHERE application_id=? AND applicant_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, applicationId);
            ps.setInt(2, applicantId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("withdrawApplication error: " + e.getMessage());
            return false;
        }
    }
}
