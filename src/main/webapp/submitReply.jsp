<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*, com.train.pkg.*" %>
<%
    String userRole = (String) session.getAttribute("role");
    int userId = (int) session.getAttribute("user_id");

    // Ensure the user is a customer or representative
    if (!"customer".equals(userRole) && !"representative".equals(userRole)) {
        response.sendRedirect("accessDenied.jsp");
        return;
    }

    ApplicationDB db = new ApplicationDB();
    Connection conn = null;
    PreparedStatement stmt = null;

    String replyText = request.getParameter("replyText");
    String queryId = request.getParameter("queryId");
    String error = null;
    String successMessage = null;

    try {
        // Ensure required parameters are provided
        if (replyText != null && !replyText.trim().isEmpty() && queryId != null && !queryId.trim().isEmpty()) {
            conn = db.getConnection();

            // Insert the reply
            String insertReplySql;
            if ("representative".equals(userRole)) {
                insertReplySql = "INSERT INTO replies (query_id, representative_id, reply_text) VALUES (?, ?, ?)";
            } else {
                insertReplySql = "INSERT INTO replies (query_id, customer_id, reply_text) VALUES (?, ?, ?)";
            }

            stmt = conn.prepareStatement(insertReplySql);
            stmt.setInt(1, Integer.parseInt(queryId));
            stmt.setInt(2, userId);
            stmt.setString(3, replyText);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                successMessage = "Reply successfully submitted.";
            } else {
                error = "Failed to submit the reply.";
            }
        } else {
            error = "Reply text and query ID are required.";
        }
    } catch (SQLException e) {
        e.printStackTrace();
        error = "An error occurred while submitting the reply.";
    } finally {
        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Submit Reply</title>
    <link rel="stylesheet" href="./styles/support.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="submit-reply-container">
        <h1>Submit Reply</h1>
        <% if (error != null) { %>
            <p class="error"><%= error %></p>
        <% } else if (successMessage != null) { %>
            <p class="success"><%= successMessage %></p>
        <% } %>
        <a href="support.jsp">Go back to Support</a>
    </div>
</body>
</html>
