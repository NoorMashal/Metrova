<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*, com.train.pkg.ApplicationDB, java.util.*" %>
<% 
    ApplicationDB db = new ApplicationDB();
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String stationName = request.getParameter("stationName");
    String error = null;

    // To store results in memory before closing ResultSet
    List<Map<String, String>> schedules = new ArrayList<>();

    try {
        conn = db.getConnection();

        if (stationName != null && !stationName.trim().isEmpty()) {
            String query = "SELECT t.line_name, s.stop_number, s.arrival_time, s.departure_time, st.station_name " +
                           "FROM stops s " +
                           "JOIN train t ON t.train_id = s.train_id " +
                           "JOIN stations st ON st.station_id = s.station_id " +
                           "WHERE st.station_name = ?";

            stmt = conn.prepareStatement(query);
            stmt.setString(1, stationName);

            rs = stmt.executeQuery();

            if (!rs.isBeforeFirst()) { // If no results, set error message
                error = "No schedules found for the provided station.";
            } else {
                // Store the data in a list to ensure ResultSet is closed safely
                while (rs.next()) {
                    Map<String, String> schedule = new HashMap<>();
                    schedule.put("line_name", rs.getString("line_name"));
                    schedule.put("stop_number", String.valueOf(rs.getInt("stop_number")));
                    schedule.put("arrival_time", rs.getTime("arrival_time").toString());
                    schedule.put("departure_time", rs.getTime("departure_time").toString());
                    schedule.put("station_name", rs.getString("station_name"));
                    schedules.add(schedule);
                }
            }
        } else {
            error = "Please provide a station name.";
        }
    } catch (SQLException e) {
        e.printStackTrace();
        error = "An error occurred while retrieving data.";
    } finally {
        // Ensure resources are closed
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Station Schedules</title>
    <link rel="stylesheet" href="./styles/stationSchedules.css">
    <link rel="stylesheet" href="./styles/home.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="schedules-container">
        <h1>Station Schedules</h1>
        
        <% if (error != null) { %>
            <p class="error"><%= error %></p>
        <% } %>
        
        <form method="GET" action="stationSchedules.jsp">
            <label for="stationName">Station Name:</label>
            <input type="text" id="stationName" name="stationName" value="<%= stationName != null ? stationName : "" %>" required>
            
            <button type="submit">Search</button>
        </form>

        <% if (!schedules.isEmpty()) { %>
            <table>
                <thead>
                    <tr>
                        <th>Line Name</th>
                        <th>Stop Number</th>
                        <th>Arrival Time</th>
                        <th>Departure Time</th>
                        <th>Station Name</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, String> schedule : schedules) { %>
                        <tr>
                            <td><%= schedule.get("line_name") %></td>
                            <td><%= schedule.get("stop_number") %></td>
                            <td><%= schedule.get("arrival_time") %></td>
                            <td><%= schedule.get("departure_time") %></td>
                            <td><%= schedule.get("station_name") %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</body>
</html>
