<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*, com.train.pkg.*" %>
<%
    // Ensure user is logged in and has a representative role
    String userRole = (String) session.getAttribute("role");

    if (!"representative".equals(userRole)) {
        response.sendRedirect("accessDenied.jsp");
        return;
    }

    // Get the query ID from the request
    String queryId = request.getParameter("queryId");
    String error = null;
    String successMessage = null;

    // Database connection
    ApplicationDB db = new ApplicationDB();
    Connection conn = null;
    PreparedStatement deleteRepliesStmt = null;
    PreparedStatement deleteQueryStmt = null;

    try {
        if (queryId != null && !queryId.trim().isEmpty()) {
            conn = db.getConnection();

            // First, delete all replies associated with the query
            String deleteRepliesSql = "DELETE FROM replies WHERE query_id = ?";
            deleteRepliesStmt = conn.prepareStatement(deleteRepliesSql);
            deleteRepliesStmt.setInt(1, Integer.parseInt(queryId));
            deleteRepliesStmt.executeUpdate();

            // Then, delete the query itself
            String deleteQuerySql = "DELETE FROM queries WHERE query_id = ?";
            deleteQueryStmt = conn.prepareStatement(deleteQuerySql);
            deleteQueryStmt.setInt(1, Integer.parseInt(queryId));
            int rowsAffected = deleteQueryStmt.executeUpdate();

            if (rowsAffected > 0) {
                successMessage = "The query has been successfully deleted.";
            } else {
                error = "Failed to delete the query. It may not exist.";
            }
        } else {
            error = "Query ID is required.";
        }
    } catch (SQLException e) {
        e.printStackTrace();
        error = "An error occurred while deleting the query.";
    } finally {
        // Close resources
        if (deleteRepliesStmt != null) try { deleteRepliesStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (deleteQueryStmt != null) try { deleteQueryStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Delete Query</title>
    <link rel="stylesheet" href="./styles/support.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="delete-query-container">
        <h1>Delete Query</h1>
        <% if (error != null) { %>
            <p class="error"><%= error %></p>
        <% } else if (successMessage != null) { %>
            <p class="success"><%= successMessage %></p>
        <% } %>
        <a href="support.jsp">Go back to Support</a>
    </div>
</body>
</html>
