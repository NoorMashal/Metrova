<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*, com.train.pkg.*" %>
<%
    // Ensure the user is a customer
    String userRole = (String) session.getAttribute("role");
    if (!"customer".equals(userRole)) {
        response.sendRedirect("accessDenied.jsp");
        return;
    }

    // Get the customer ID and query text from the session and request
    Integer customerId = (Integer) session.getAttribute("user_id");
    String queryText = request.getParameter("queryText");

    if (customerId == null || queryText == null || queryText.trim().isEmpty()) {
        response.sendRedirect("support.jsp?error=missingFields");
        return;
    }

    ApplicationDB db = new ApplicationDB();
    Connection conn = null;
    PreparedStatement pstmt = null;

    String error = null;

    try {
        conn = db.getConnection();

        // Insert the new query into the database
        String insertQuerySql = "INSERT INTO queries (customer_id, query_text) VALUES (?, ?)";
        pstmt = conn.prepareStatement(insertQuerySql);
        pstmt.setInt(1, customerId);
        pstmt.setString(2, queryText);

        int rowsInserted = pstmt.executeUpdate();

        if (rowsInserted > 0) {
            response.sendRedirect("support.jsp?success=Your question has been submitted.");
        } else {
            response.sendRedirect("support.jsp?error=Failed to submit your question.");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("support.jsp?error=Database error occurred.");
    } finally {
        // Close database resources
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
