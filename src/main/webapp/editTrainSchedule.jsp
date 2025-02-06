<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*, com.train.pkg.*" %>
<%
    String UserRole = (String) session.getAttribute("role");
    if (!"representative".equals(UserRole)) {
        response.sendRedirect("accessDenied.jsp");
        return;
    }

    int trainId = Integer.parseInt(request.getParameter("trainId"));
    ApplicationDB db = new ApplicationDB();
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String lineName = "";
    int originStation = 0;
    int destinationStation = 0;
    int stops = 0;
    double fare = 0.0;
    Time travelTime = null;

    try {
        conn = db.getConnection();
        String sql = "SELECT * FROM train WHERE train_id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, trainId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            lineName = rs.getString("line_name");
            originStation = rs.getInt("origin_station_id");
            destinationStation = rs.getInt("destination_station_id");
            stops = rs.getInt("num_stops");
            fare = rs.getDouble("total_fare");
            travelTime = rs.getTime("total_travel_time");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Train Schedule</title>
</head>
<body>
    <%@ include file="header.jsp" %>
    <h1>Edit Train Schedule</h1>
    <form action="updateTrainSchedule.jsp" method="POST">
        <input type="hidden" name="trainId" value="<%= trainId %>">
        <label>Line Name:</label>
        <input type="text" name="lineName" value="<%= lineName %>" required>
        <label>Origin Station ID:</label>
        <input type="number" name="originStation" value="<%= originStation %>" required>
        <label>Destination Station ID:</label>
        <input type="number" name="destinationStation" value="<%= destinationStation %>" required>
        <label>Number of Stops:</label>
        <input type="number" name="stops" value="<%= stops %>" required>
        <label>Total Fare:</label>
        <input type="number" step="0.01" name="fare" value="<%= fare %>" required>
        <label>Travel Time:</label>
        <input type="time" name="travelTime" value="<%= travelTime %>" required>
        <button type="submit">Update</button>
    </form>
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
