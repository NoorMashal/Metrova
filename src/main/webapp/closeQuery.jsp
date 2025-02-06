<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*, com.train.pkg.*" %>
<%
    String queryIdStr = request.getParameter("queryId");

    if (queryIdStr == null) {
        response.sendRedirect("reply.jsp?error=missingQueryId");
        return;
    }

    int queryId = Integer.parseInt(queryIdStr);
    ApplicationDB db = new ApplicationDB();
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        conn = db.getConnection();

        String deleteQuery = "DELETE FROM queries WHERE query_id = ?";
        pstmt = conn.prepareStatement(deleteQuery);
        pstmt.setInt(1, queryId);

        int rowsAffected = pstmt.executeUpdate();
        if (rowsAffected > 0) {
            response.sendRedirect("reply.jsp?success=Query marked as solved.");
        } else {
            response.sendRedirect("reply.jsp?error=Failed to mark query as solved.");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("reply.jsp?error=DatabaseError");
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
