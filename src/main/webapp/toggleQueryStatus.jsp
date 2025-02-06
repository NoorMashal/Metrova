<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*, com.train.pkg.*" %>
<%
    String userRole = (String) session.getAttribute("role");

    // Ensure the user is a representative
    if (!"representative".equals(userRole)) {
        response.sendRedirect("accessDenied.jsp");
        return;
    }

    ApplicationDB db = new ApplicationDB();
    Connection conn = null;
    PreparedStatement stmt = null;

    String queryId = request.getParameter("queryId");
    String error = null;
    String successMessage = null;

    try {
        if (queryId != null && !queryId.trim().isEmpty()) {
            conn = db.getConnection();

            // Toggle the query status
            String getStatusSql = "SELECT status FROM queries WHERE query_id = ?";
            stmt = conn.prepareStatement(getStatusSql);
            stmt.setInt(1, Integer.parseInt(queryId));
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String currentStatus = rs.getString("status");
                String newStatus = "open".equals(currentStatus) ? "solved" : "open";

                String updateStatusSql = "UPDATE queries SET status = ? WHERE query_id = ?";
                stmt = conn.prepareStatement(updateStatusSql);
                stmt.setString(1, newStatus);
                stmt.setInt(2, Integer.parseInt(queryId));
                int rowsAffected = stmt.executeUpdate();

                if (rowsAffected > 0) {
                    successMessage = "Query marked as " + (newStatus.equals("solved") ? "solved" : "unsolved") + ".";
                } else {
                    error = "Failed to update the query status.";
                }
            } else {
                error = "Query not found.";
            }
            rs.close();
        } else {
            error = "Query ID is required.";
        }
    } catch (SQLException e) {
        e.printStackTrace();
        error = "An error occurred while updating the query status.";
    } finally {
        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Toggle Query Status</title>
    <link rel="stylesheet" href="./styles/support.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="toggle-status-container">
        <h1>Toggle Query Status</h1>
        <% if (error != null) { %>
            <p class="error"><%= error %></p>
        <% } else if (successMessage != null) { %>
            <p class="success"><%= successMessage %></p>
        <% } %>
        <a href="support.jsp">Go back to Support</a>
    </div>
</body>
</html>
