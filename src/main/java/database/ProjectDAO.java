package database;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProjectDAO {

    public static boolean createProject(int creatorId, String title, String description, String category) {
        String sql = "INSERT INTO Projects (creator_id, title, description, category) VALUES (?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, creatorId);
            ps.setString(2, title);
            ps.setString(3, description);
            ps.setString(4, category);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("createProject error: " + e.getMessage());
            return false;
        }
    }

    public static List<String> listProjects() {
        List<String> result = new ArrayList<>();
        String sql = "SELECT p.project_id, u.username, p.title, p.category, p.status " +
                     "FROM Projects p JOIN Users u ON p.creator_id = u.user_id " +
                     "ORDER BY p.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.add(String.format("[ID:%d] [%s] %s by @%s | Status: %s",
                        rs.getInt("project_id"), rs.getString("category"),
                        rs.getString("title"), rs.getString("username"),
                        rs.getString("status")));
            }
        } catch (SQLException e) {
            System.out.println("listProjects error: " + e.getMessage());
        }
        return result;
    }

    public static List<String> searchByCategory(String category) {
        List<String> result = new ArrayList<>();
        String sql = "SELECT p.project_id, u.username, p.title, p.status " +
                     "FROM Projects p JOIN Users u ON p.creator_id = u.user_id " +
                     "WHERE p.category = ? ORDER BY p.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, category);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(String.format("[ID:%d] %s by @%s | %s",
                            rs.getInt("project_id"), rs.getString("title"),
                            rs.getString("username"), rs.getString("status")));
                }
            }
        } catch (SQLException e) {
            System.out.println("searchByCategory error: " + e.getMessage());
        }
        return result;
    }

    public static String getProjectById(int projectId) {
        String sql = "SELECT p.project_id, u.username, p.title, p.description, p.category, p.status, p.created_at " +
                     "FROM Projects p JOIN Users u ON p.creator_id = u.user_id WHERE p.project_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return String.format("[ID:%d] \"%s\" by @%s\n  Category: %s | Status: %s\n  %s\n  Posted: %s",
                            rs.getInt("project_id"), rs.getString("title"),
                            rs.getString("username"), rs.getString("category"),
                            rs.getString("status"), rs.getString("description"),
                            rs.getTimestamp("created_at"));
                }
            }
        } catch (SQLException e) {
            System.out.println("getProjectById error: " + e.getMessage());
        }
        return null;
    }

    public static List<String> getProjectsByCreator(int creatorId) {
        List<String> result = new ArrayList<>();
        String sql = "SELECT project_id, title, category, status FROM Projects WHERE creator_id = ? ORDER BY created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, creatorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(String.format("[ID:%d] [%s] %s | %s",
                            rs.getInt("project_id"), rs.getString("category"),
                            rs.getString("title"), rs.getString("status")));
                }
            }
        } catch (SQLException e) {
            System.out.println("getProjectsByCreator error: " + e.getMessage());
        }
        return result;
    }

    public static boolean updateProject(int projectId, int creatorId, String title,
                                        String description, String category, String status) {
        String sql = "UPDATE Projects SET title=?, description=?, category=?, status=? " +
                     "WHERE project_id=? AND creator_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, category);
            ps.setString(4, status);
            ps.setInt(5, projectId);
            ps.setInt(6, creatorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("updateProject error: " + e.getMessage());
            return false;
        }
    }

    public static boolean deleteProject(int projectId, int creatorId) {
        String sql = "DELETE FROM Projects WHERE project_id=? AND creator_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            ps.setInt(2, creatorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("deleteProject error: " + e.getMessage());
            return false;
        }
    }
}
