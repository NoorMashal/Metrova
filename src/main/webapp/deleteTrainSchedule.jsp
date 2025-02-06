<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*, com.train.pkg.*" %>
<%
    String role = (String) session.getAttribute("role");
    if (!"representative".equals(role)) {
        response.sendRedirect("accessDenied.jsp");
        return;
    }

    int trainId = Integer.parseInt(request.getParameter("trainId"));
    ApplicationDB db = new ApplicationDB();
    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        conn = db.getConnection();
        String sql = "DELETE FROM train WHERE train_id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, trainId);
        int rowsDeleted = stmt.executeUpdate();

        if (rowsDeleted > 0) {
            response.sendRedirect("trainSchedules.jsp?success=Schedule deleted successfully.");
        } else {
            response.sendRedirect("trainSchedules.jsp?error=Failed to delete schedule.");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("trainSchedules.jsp?error=Database error occurred.");
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
