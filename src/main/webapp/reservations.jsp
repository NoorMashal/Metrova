<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.train.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.net.URLEncoder" %>

<%
    ResultSet resultSet = null;
    boolean hasResults = false;
    try {
        ApplicationDB db = new ApplicationDB();	
        Connection con = db.getConnection();

        String query = 
            "SELECT t.line_name, t.train_id, r.reservation_id, r.fare, r.booking_date, " +
            "origin.departure_time, dest.arrival_time, s1.station_name AS origin_station, s2.station_name AS destination_station " +
            "FROM reservation r " +
            "JOIN stops origin ON origin.stop_id = r.origin_stop_id " +
            "JOIN stops dest ON dest.stop_id = r.destination_stop_id " +
            "JOIN train t ON t.train_id = origin.train_id " +
            "JOIN stations s1 ON s1.station_id = origin.station_id " +
            "JOIN stations s2 ON s2.station_id = dest.station_id " +
            "WHERE r.user_id = ?";

		
        PreparedStatement stmt = con.prepareStatement(query);
        stmt.setInt(1, (Integer) session.getAttribute("user_id"));
        resultSet = stmt.executeQuery();

        hasResults = resultSet.next();
        if (!hasResults) {
            out.println("You have no reservations!<br>");
            response.setHeader("Refresh", "3;url=home.jsp");
            out.print("Redirecting to home page....");
            return;
        }

    } catch (Exception e) {
        out.print("An error occurred: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>reservations</title>
    <link rel="stylesheet" href="./styles/path.css">
    <link rel="stylesheet" href="./styles/home.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <% 
    while (hasResults) { 
        String departureTime = resultSet.getString("departure_time");
        String arrivalTime = resultSet.getString("arrival_time");
        String originStation = resultSet.getString("origin_station");
        String destinationStation = resultSet.getString("destination_station");
        String trainLine = resultSet.getString("line_name");
        String trainId = resultSet.getString("train_id");
        double totalFare = resultSet.getDouble("fare");
        String date = resultSet.getString("booking_date");
        int reservationId = resultSet.getInt("reservation_id");
        totalFare = Math.round(totalFare * 100.0) / 100.0;

        String formattedTrainPrice = String.format("%.2f", totalFare);
    %>
        <div class="train-card">
            <div class="train-content">
                <div class="train-info">
                    <div class="left-side">
                        <span class="time"><%= departureTime %></span> Depart <%= originStation %>
                    </div>
                    <div class="right-side">
                        <%= trainLine %> #<%= trainId %>
                    </div>
                </div>
                <div class="train-info">
                    <div class="left-side">
                        <span class="time"><%= arrivalTime %></span> Arrive <%= destinationStation %>
                    </div>
                    <div class="right-side">
                        stops
                    </div>
                </div>
                <div class="train-info">
                    <div class="left-side">
                        <span class="time"><%= date %></span>$<%= formattedTrainPrice %>
                    </div>
                    <div class="right-side">
                        <form action="cancel.jsp" method="POST">
                            <input type="hidden" name="reservation" value="<%= reservationId %>"/>
                            <input type="submit" value="Cancel Reservation" class="reserve-button"/>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    <% 
        hasResults = resultSet.next(); 
    } 
    %>
</body>
</html>