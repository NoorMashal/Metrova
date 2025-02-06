<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.train.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.net.URLEncoder" %>


<%
    ArrayList<String> stations = new ArrayList<>(); 
    String origin = request.getParameter("origin").trim();
    String destination = request.getParameter("destination").trim();
    String date = request.getParameter("travelDate");
    ResultSet resultSet = null;
    boolean hasResults = false;
    try {
        ApplicationDB db = new ApplicationDB();	
        Connection con = db.getConnection();

        String query = 
            "SELECT " +
            "    t.train_id, " +
            "    t.line_name, " +
            "    t.total_fare, " + // Include total fare
            "    origin_st.station_name AS origin_station, " +
            "    dest_st.station_name AS destination_station, " +
            "    origin.stop_id AS origin_stop_id, " + // Include origin stop ID
            "    destination.stop_id AS destination_stop_id, " + // Include destination stop ID
            "    (destination.stop_number - origin.stop_number + 1) AS total_stops, " +
            "    origin.departure_time AS departure_time, " +
            "    destination.arrival_time AS arrival_time " +
            "FROM stops origin " +
            "JOIN stops destination ON origin.train_id = destination.train_id " +
            "                       AND origin.stop_number < destination.stop_number " + // Ensure destination comes after origin
            "JOIN train t ON t.train_id = origin.train_id " +
            "JOIN stations origin_st ON origin_st.station_id = origin.station_id " +
            "JOIN stations dest_st ON dest_st.station_id = destination.station_id " +
            "WHERE origin_st.station_name = ? " + // Replace with origin station
            "  AND dest_st.station_name = ? " + // Replace with destination station
            "ORDER BY origin.departure_time;";

		
        PreparedStatement stmt = con.prepareStatement(query);
        stmt.setString(1, origin);
        stmt.setString(2, destination);
        resultSet = stmt.executeQuery();

       	hasResults = resultSet.next();
        if (!hasResults) {
            out.println("There are no trains for this schedule!");
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
    <title>Document</title>
    <link rel="stylesheet" href="./styles/path.css">
</head>
<body>
    <% 
    while (hasResults) { 
        String departureTime = resultSet.getString("departure_time");
        String arrivalTime = resultSet.getString("arrival_time");
        String originStation = resultSet.getString("origin_station");
        String destinationStation = resultSet.getString("destination_station");
        String trainLine = resultSet.getString("line_name");
        String trainId = resultSet.getString("train_id");
        int totalStops = resultSet.getInt("total_stops");
        int originId = resultSet.getInt("origin_stop_id");
        int destinationId = resultSet.getInt("destination_stop_id");
        double totalFare = resultSet.getDouble("total_fare");
        double trainPrice = totalFare / totalStops;
        trainPrice = Math.round(trainPrice * 100.0) / 100.0;

        String formattedTrainPrice = String.format("%.2f", trainPrice);
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
                        <%= totalStops %> stops
                    </div>
                </div>
                <div class="train-info">
                    <div class="left-side"></div>
                    <div class="right-side">
                        <form action="reserve.jsp" method="POST">
                            <input type="hidden" name="user_id" value="<%= session.getAttribute("user_id") %>"/> 
                            <input type="hidden" name="origin_stop" value="<%= originId %>"/> 
                            <input type="hidden" name="destination_stop" value="<%= destinationId %>"/>
                            <input type="hidden" name="fare" value="<%= trainPrice %>"/> <!-- Pass the train line -->
                            <input type="hidden" name="date" value="<%=date%>"/> <!-- Pass the booking date -->
                            <input type="submit" value="Reserve $<%= formattedTrainPrice%>" class="reserve-button"/>
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