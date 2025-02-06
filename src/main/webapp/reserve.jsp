<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.train.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.math.BigDecimal" %>

<%
    // Retrieve parameters from the form submission
    String userId = request.getParameter("user_id");
    String originStop = request.getParameter("origin_stop");
    String destStop = request.getParameter("destination_stop");
    String fare = request.getParameter("fare");
    String date = request.getParameter("date");


    out.print("User ID: " + userId + "<br>");
    out.print("Origin Stop: " + originStop + "<br>");
    out.print("Destination Stop: " + destStop + "<br>");
    out.print("Fare: " + fare + "<br>");
    out.print("Date: " + date + "<br>");


    try {
        ApplicationDB db = new ApplicationDB();	
        Connection con = db.getConnection();
    
        String checkQuery = "SELECT COUNT(*) AS count FROM Reservation WHERE user_id = ? AND origin_stop_id = ? AND destination_stop_id = ? AND booking_date = ?";
        PreparedStatement checkStmt = con.prepareStatement(checkQuery);
        checkStmt.setString(1, userId);
        checkStmt.setString(2, originStop);
        checkStmt.setString(3, destStop);
        checkStmt.setString(4, date);

        ResultSet resultSet = checkStmt.executeQuery();
        resultSet.next();
        int count = resultSet.getInt("count");

        if (count > 0) {
            out.print("<p>You already have this reservation.</p>");
        } else {
            // Insert the new reservation
            String insertQuery = "INSERT INTO Reservation (user_id, origin_stop_id, destination_stop_id, fare, booking_date) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement insertStmt = con.prepareStatement(insertQuery);

            // Use BigDecimal for fare to handle DECIMAL(10,2)
            BigDecimal fareValue = new BigDecimal(fare);

            insertStmt.setString(1, userId);
            insertStmt.setString(2, originStop);
            insertStmt.setString(3, destStop);
            insertStmt.setBigDecimal(4, fareValue); // Use BigDecimal for fare
            insertStmt.setString(5, date);

            int rowsInserted = insertStmt.executeUpdate();
            if (rowsInserted > 0) {
                out.print("<p>Reservation successfully made!</p>");
            } else {
                out.print("<p>Failed to make a reservation. Please try again.</p>");
            }
        }

        out.print("Redirecting to home page...");
        response.setHeader("Refresh", "3;url=home.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        out.print("<p>Error: " + e.getMessage() + "</p>");
    } 
%>