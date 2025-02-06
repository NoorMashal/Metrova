<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*, java.math.BigDecimal, com.train.pkg.*" %>
<%
    // Ensure user has the representative role
    String userRole = (String) session.getAttribute("role");
    if (!"representative".equals(userRole)) {
        response.sendRedirect("accessDenied.jsp");
        return;
    }

    ApplicationDB db = new ApplicationDB();
    Connection conn = null;
    PreparedStatement selectStmt = null;
    PreparedStatement updateStmt = null;
    ResultSet rs = null;

    String error = null;
    String success = null;

    // Retrieve the train_id from the request
    String trainId = request.getParameter("trainId");

    String lineName = null;
    int numStops = 0;
    BigDecimal totalFare = null;
    Time totalTravelTime = null;
    int originStationId = 0;
    int destinationStationId = 0;

    if (trainId == null || trainId.trim().isEmpty()) {
        error = "Train ID is required to update the schedule.";
    } else {
        try {
            conn = db.getConnection();

            // Fetch the train schedule details
            String selectSql = "SELECT train_id, line_name, num_stops, total_fare, total_travel_time, origin_station_id, destination_station_id FROM train WHERE train_id = ?";
            selectStmt = conn.prepareStatement(selectSql);
            selectStmt.setInt(1, Integer.parseInt(trainId));
            rs = selectStmt.executeQuery();

            if (rs.next()) {
                lineName = rs.getString("line_name");
                numStops = rs.getInt("num_stops");
                totalFare = rs.getBigDecimal("total_fare");
                totalTravelTime = rs.getTime("total_travel_time");
                originStationId = rs.getInt("origin_station_id");
                destinationStationId = rs.getInt("destination_station_id");
            } else {
                error = "Train schedule not found for Train ID: " + trainId;
            }

            // If form is submitted, update the train schedule
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                lineName = request.getParameter("lineName");
                String numStopsParam = request.getParameter("numStops");
                String totalFareParam = request.getParameter("totalFare");
                String totalTravelTimeParam = request.getParameter("totalTravelTime");
                String originStationIdParam = request.getParameter("originStationId");
                String destinationStationIdParam = request.getParameter("destinationStationId");

                if (lineName == null || lineName.trim().isEmpty() ||
                    numStopsParam == null || numStopsParam.trim().isEmpty() ||
                    totalFareParam == null || totalFareParam.trim().isEmpty() ||
                    totalTravelTimeParam == null || totalTravelTimeParam.trim().isEmpty() ||
                    originStationIdParam == null || originStationIdParam.trim().isEmpty() ||
                    destinationStationIdParam == null || destinationStationIdParam.trim().isEmpty()) {
                    error = "All fields are required.";
                } else {
                    try {
                        numStops = Integer.parseInt(numStopsParam);
                        totalFare = new BigDecimal(totalFareParam);
                        totalTravelTime = Time.valueOf(totalTravelTimeParam);
                        originStationId = Integer.parseInt(originStationIdParam);
                        destinationStationId = Integer.parseInt(destinationStationIdParam);

                        String updateSql = "UPDATE train SET line_name = ?, num_stops = ?, total_fare = ?, total_travel_time = ?, origin_station_id = ?, destination_station_id = ? WHERE train_id = ?";
                        updateStmt = conn.prepareStatement(updateSql);
                        updateStmt.setString(1, lineName);
                        updateStmt.setInt(2, numStops);
                        updateStmt.setBigDecimal(3, totalFare);
                        updateStmt.setTime(4, totalTravelTime);
                        updateStmt.setInt(5, originStationId);
                        updateStmt.setInt(6, destinationStationId);
                        updateStmt.setInt(7, Integer.parseInt(trainId));

                        int rowsUpdated = updateStmt.executeUpdate();

                        if (rowsUpdated > 0) {
                            success = "Train schedule updated successfully.";
                        } else {
                            error = "Failed to update train schedule.";
                        }
                    } catch (NumberFormatException e) {
                        error = "Invalid input format for one or more fields.";
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            error = "An error occurred while updating the train schedule.";
        } finally {
            // Close database resources
            try {
                if (rs != null) rs.close();
                if (selectStmt != null) selectStmt.close();
                if (updateStmt != null) updateStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Update Train Schedule</title>
    <link rel="stylesheet" href="./styles/updateTrainSchedule.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="update-train-schedule-container">
        <h1>Update Train Schedule</h1>

        <% if (error != null) { %>
            <p class="error"><%= error %></p>
        <% } %>

        <% if (success != null) { %>
            <p class="success"><%= success %></p>
        <% } %>

        <% if (lineName != null) { %>
		<form action="updateTrainSchedule.jsp?trainId=<%= trainId %>" method="POST">
		    <label for="lineName">Line Name:</label>
		    <input type="text" id="lineName" name="lineName" 
		           value="<%= request.getParameter("lineName") != null ? request.getParameter("lineName") : lineName %>" required>
		
		    <label for="numStops">Number of Stops:</label>
		    <input type="number" id="numStops" name="numStops" 
		           value="<%= request.getParameter("numStops") != null ? request.getParameter("numStops") : numStops %>" required>
		
		    <label for="totalFare">Total Fare:</label>
		    <input type="text" id="totalFare" name="totalFare" 
		           value="<%= request.getParameter("totalFare") != null ? request.getParameter("totalFare") : totalFare %>" required>
		
		    <label for="totalTravelTime">Total Travel Time (HH:MM:SS):</label>
		    <input type="text" id="totalTravelTime" name="totalTravelTime" 
		           value="<%= request.getParameter("totalTravelTime") != null ? request.getParameter("totalTravelTime") : totalTravelTime %>" required>
		
		    <label for="originStationId">Origin Station ID:</label>
		    <input type="number" id="originStationId" name="originStationId" 
		           value="<%= request.getParameter("originStationId") != null ? request.getParameter("originStationId") : originStationId %>" required>
		
		    <label for="destinationStationId">Destination Station ID:</label>
		    <input type="number" id="destinationStationId" name="destinationStationId" 
		           value="<%= request.getParameter("destinationStationId") != null ? request.getParameter("destinationStationId") : destinationStationId %>" required>
		
		    <button type="submit">Update Schedule</button>
		</form>
		<% } %>
    </div>
</body>
</html>
