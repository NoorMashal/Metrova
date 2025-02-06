<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*, com.train.pkg.ApplicationDB, java.util.*" %>
<% 
    ApplicationDB db = new ApplicationDB();
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String lineName = request.getParameter("lineName");
    String bookingDate = request.getParameter("bookingDate");
    String error = null;

    // To store results in memory before closing ResultSet
    List<Map<String, String>> reservations = new ArrayList<>();

    try {
        conn = db.getConnection();

        if (lineName != null && bookingDate != null && !lineName.trim().isEmpty() && !bookingDate.trim().isEmpty()) {
            String formattedBookingDate = bookingDate;

            String query = "SELECT u.first_name, u.last_name, r.booking_date, t.line_name " +
                    "FROM reservation r " +
                    "JOIN users u ON r.user_id = u.user_id " +
                    "JOIN stops s ON s.stop_id = r.origin_stop_id " +
                    "JOIN train t ON t.train_id = s.train_id " +
                    "WHERE t.line_name = ? AND r.booking_date = ?";

            stmt = conn.prepareStatement(query);
            stmt.setString(1, lineName);
            stmt.setString(2, formattedBookingDate);

            rs = stmt.executeQuery();

            if (!rs.isBeforeFirst()) { // If no results, set error message
                error = "No reservations found for the provided Line Name and Booking Date.";
            } else {
                // Store the data in a list to ensure ResultSet is closed safely
                while (rs.next()) {
                    Map<String, String> reservation = new HashMap<>();
                    reservation.put("first_name", rs.getString("first_name"));
                    reservation.put("last_name", rs.getString("last_name"));
                    reservation.put("booking_date", rs.getDate("booking_date").toString());
                    reservation.put("line_name", rs.getString("line_name"));
                    reservations.add(reservation);
                }
            }
        } else {
            error = "Please provide both Line Name and Booking Date.";
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
    <title>Customer Reservations</title>
    <link rel="stylesheet" href="./styles/customerReservations.css">
    <link rel="stylesheet" href="./styles/home.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="reservations-container">
        <h1>Customer Reservations</h1>
        
        <% if (error != null) { %>
            <p class="error"><%= error %></p>
        <% } %>
        
        <form method="GET" action="customerReservations.jsp">
            <label for="lineName">Line Name:</label>
            <input type="text" id="lineName" name="lineName" value="<%= lineName != null ? lineName : "" %>" required>
            
            <label for="bookingDate">Booking Date (YYYY-MM-DD):</label>
            <input type="date" id="bookingDate" name="bookingDate" value="<%= bookingDate != null ? bookingDate : "" %>" required>
            
            <button type="submit">Search</button>
        </form>

        <% if (!reservations.isEmpty()) { %>
            <table>
                <thead>
                    <tr>
                        <th>First Name</th>
                        <th>Last Name</th>
                        <th>Booking Date</th>
                        <th>Line Name</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, String> reservation : reservations) { %>
                        <tr>
                            <td><%= reservation.get("first_name") %></td>
                            <td><%= reservation.get("last_name") %></td>
                            <td><%= reservation.get("booking_date") %></td>
                            <td><%= reservation.get("line_name") %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</body>
</html>
