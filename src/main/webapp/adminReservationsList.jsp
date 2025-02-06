<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.train.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
	ArrayList<String> transitLines = new ArrayList<>();
	ArrayList<String[]> reservations = new ArrayList<>();
	String selectedTransitLine = request.getParameter("transitLine");
	String customerName = request.getParameter("customerName");

	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	
	String lineQuery = "SELECT DISTINCT line_name FROM train ORDER BY line_name";
	Statement lineStatement = con.createStatement();
	ResultSet lineResultSet = lineStatement.executeQuery(lineQuery);
	
	while(lineResultSet.next()){
		transitLines.add(lineResultSet.getString("line_name"));
	}
	
	String query = "SELECT r.reservation_id, r.fare, r.booking_date, t.line_name AS transit_line, " + 
	"CONCAT(u.first_name, ' ' , u.last_name) AS customer_name " + 
	"FROM reservation r " + 
	"JOIN users u ON u.user_id = r.user_id " + 
	"JOIN stops origin ON origin.stop_id = r.origin_stop_id " + 
	"JOIN train t ON t.train_id = origin.train_id " + 
	"WHERE (? IS NULL OR t.line_name = ?) " + 
	"AND (? IS NULL OR CONCAT(u.first_name, ' ', u.last_name) = ?)";
	
	PreparedStatement statement = con.prepareStatement(query);

	if (selectedTransitLine == null || selectedTransitLine.isEmpty()) {
	    statement.setNull(1, Types.VARCHAR);
	    statement.setNull(2, Types.VARCHAR);
	} else {
	    statement.setString(1, selectedTransitLine);
	    statement.setString(2, selectedTransitLine);
	}

	if (customerName == null || customerName.isEmpty()) {
	    statement.setNull(3, Types.VARCHAR);
	    statement.setNull(4, Types.VARCHAR);
	} else {
	    statement.setString(3, customerName);
	    statement.setString(4, customerName);
	}

	ResultSet resultSet = statement.executeQuery();
	while(resultSet.next()){
		reservations.add(new String[]{
            resultSet.getString("reservation_id"),
            resultSet.getString("fare"),
            resultSet.getString("booking_date"),
            resultSet.getString("transit_line"),
            resultSet.getString("customer_name")
        });
	}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="./styles/home.css">
</head>
<body>
	<form action="home.jsp">
		<button type="submit">Back</button>
	</form>
	<form method="GET" action="adminReservationsList.jsp">
		<label for="transitLine">Transit Line: </label>
		<select name="transitLine">
			<option value="">All</option>
			<% for (String transitLine : transitLines) { %>
				<option value="<%=transitLine%>" <%= (transitLine.equals(selectedTransitLine) ? "selected" : "") %>><%= transitLine %></option>
			<% } %>
		</select>
		<label for="customerName">Customer Name: </label>
		<input type="text" name="customerName" value="<%= (customerName != null ? customerName : "") %>">
		<button type="submit">Filter</button>
	</form>
	
	<table>
        <thead>
            <tr>
                <th>Reservation ID</th>
                <th>Fare</th>
                <th>Booking Date</th>
                <th>Transit Line</th>
                <th>Customer Name</th>
            </tr>
        </thead>
        <tbody>
            <% for (String[] reservation : reservations) { %>
                <tr>
                    <td><%= reservation[0] %></td>
                    <td><%= reservation[1] %></td>
                    <td><%= reservation[2] %></td>
                    <td><%= reservation[3] %></td>
                    <td><%= reservation[4] %></td>
                </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>