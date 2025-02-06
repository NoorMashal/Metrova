<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*, com.train.pkg.*" %>
<%
    String UserRole = (String) session.getAttribute("role");
    if (!"representative".equals(UserRole)) {
        response.sendRedirect("accessDenied.jsp");
        return;
    }

    ApplicationDB db = new ApplicationDB();
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = db.getConnection();
        String sql = "SELECT train_id, line_name, origin_station_id, destination_station_id, num_stops, total_fare, total_travel_time FROM train ORDER BY train_id";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Train Schedules</title>
    <link rel="stylesheet" href="./styles/trainSchedules.css">
    <link rel="stylesheet" href="./styles/home.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="schedule-container">
        <h1>Manage Train Schedules</h1>
        <table>
            <thead>
                <tr>
                    <th>Train ID</th>
                    <th>Line Name</th>
                    <th>Origin Station</th>
                    <th>Destination Station</th>
                    <th>Stops</th>
                    <th>Total Fare</th>
                    <th>Travel Time</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    while (rs.next()) {
                        int trainId = rs.getInt("train_id");
                        String lineName = rs.getString("line_name");
                        int originStation = rs.getInt("origin_station_id");
                        int destinationStation = rs.getInt("destination_station_id");
                        int stops = rs.getInt("num_stops");
                        double fare = rs.getDouble("total_fare");
                        Time travelTime = rs.getTime("total_travel_time");
                %>
                <tr>
                    <td><%= trainId %></td>
                    <td><%= lineName %></td>
                    <td><%= originStation %></td>
                    <td><%= destinationStation %></td>
                    <td><%= stops %></td>
                    <td>$<%= fare %></td>
                    <td><%= travelTime %></td>
                    <td>
                        <form action="updateTrainSchedule.jsp" method="GET" style="display:inline;">
                            <input type="hidden" name="trainId" value="<%= trainId %>">
                            <button type="submit">Edit</button>
                        </form>
                        <form action="deleteTrainSchedule.jsp" method="POST" style="display:inline;">
                            <input type="hidden" name="trainId" value="<%= trainId %>">
                            <button type="submit" onclick="return confirm('Are you sure you want to delete this schedule?')">Delete</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>

<%
    try {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
