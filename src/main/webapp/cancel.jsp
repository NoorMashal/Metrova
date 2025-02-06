<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.train.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.net.URLEncoder" %>

<%
    try {
        ApplicationDB db = new ApplicationDB();	
        Connection con = db.getConnection();		

        // Get the reservation ID from the request
        String reservationID = request.getParameter("reservation");

        // Validate the input
        if (reservationID != null && !reservationID.isEmpty()) {
            String query = "DELETE FROM reservation WHERE reservation_id = ?";
            
            // Use PreparedStatement to prevent SQL injection
            PreparedStatement pstmt = con.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(reservationID)); // Convert the string to an integer

            int rowsAffected = pstmt.executeUpdate(); // Execute the delete query

            if (rowsAffected > 0) {
                out.println("Reservation deleted successfully.<br>");
            } else {
                out.println("No reservation found with the given ID.<br>");
            }

            pstmt.close(); // Close the PreparedStatement
        } else {
            out.println("Invalid reservation ID.<br>");
        }
        response.setHeader("Refresh", "3;url=home.jsp");
        out.print("Redirecting to home page....");

        con.close(); // Close the connection
    } catch (Exception e) {
        e.printStackTrace(); // Log the exception for debugging
        out.println("An error occurred while deleting the reservation.");
    }
%>