<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.train.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
	// retrieve all sales for the past month
	ArrayList<String> salesMonths = new ArrayList<>();
	ArrayList<Double> totalSales = new ArrayList<>();
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	
	String query = "SELECT DATE_FORMAT(r.booking_date, '%Y-%m') AS sales_month, SUM(r.fare) AS total_sales " + 
	"FROM reservation r GROUP BY sales_month ORDER BY sales_month";
	Statement statement = con.createStatement();
	ResultSet resultSet = statement.executeQuery(query);
	
	while(resultSet.next()){
		salesMonths.add(resultSet.getString("sales_month"));
		totalSales.add(resultSet.getDouble("total_sales"));
	}
	
	// get total revenue for each transit line and customer
	ArrayList<String> transitLines = new ArrayList<>();
	String selectedTransitLine = request.getParameter("transitLine");
	String customerName = request.getParameter("customerName");
	
	String lineQuery = "SELECT DISTINCT line_name FROM train ORDER BY line_name";
	Statement lineStatement = con.createStatement();
	ResultSet lineResultSet = lineStatement.executeQuery(lineQuery);
	
	while(lineResultSet.next()){
		transitLines.add(lineResultSet.getString("line_name"));
	}
	
	String customerRevenueQuery = "SELECT CONCAT(u.first_name, ' ', u.last_name) AS customer_name, " +
			"SUM(r.fare) AS total_revenue " +
			"FROM reservation r JOIN users u ON u.user_id = r.user_id " +
			"GROUP BY customer_name " +
			"ORDER BY total_revenue DESC";
	
	String transitLineRevenueQuery = "SELECT t.line_name AS transit_line, " +
			"SUM(r.fare) AS total_revenue " +
			"FROM reservation r " +
			"JOIN stops origin ON origin.stop_id = r.origin_stop_id " +
			"JOIN train t ON t.train_id = origin.train_id " +
			"GROUP BY t.line_name " +
			"ORDER BY total_revenue DESC";
	
	PreparedStatement customerPs = con.prepareStatement(customerRevenueQuery);
	ResultSet customerRs = customerPs.executeQuery();
	
	ArrayList<String[]> customerRevenueData = new ArrayList<>();
	while(customerRs.next()){
		customerRevenueData.add(new String[]{
			customerRs.getString("customer_name"),
			customerRs.getString("total_revenue")
		});
	}
	
	// Prepare transit line revenue statement
	PreparedStatement transitLinePs = con.prepareStatement(transitLineRevenueQuery);
	ResultSet transitLineRs = transitLinePs.executeQuery();
	
	ArrayList<String[]> transitLineRevenueData = new ArrayList<>();
	while(transitLineRs.next()){
		transitLineRevenueData.add(new String[]{
			transitLineRs.getString("transit_line"),
			transitLineRs.getString("total_revenue")
		});
	}
	
	// getting best customer through revenue and reservations
	String bestCustomerQuery = "SELECT CONCAT(u.first_name, ' ', u.last_name) AS customer_name, " +
    "SUM(r.fare) AS total_revenue, " +
    "COUNT(r.reservation_id) AS total_reservations " +
    "FROM reservation r " +
    "JOIN users u ON u.user_id = r.user_id " +
    "GROUP BY customer_name " +
    "ORDER BY total_revenue DESC " +
    "LIMIT 1";
    
    PreparedStatement bestCustomerPs = con.prepareStatement(bestCustomerQuery);
    ResultSet bestCustomerRs = bestCustomerPs.executeQuery();
    
    String bestCustomerName = "N/A";
    double bestCustomerRevenue = 0;
    int bestCustomerReservations = 0;
    
    if (bestCustomerRs.next()) {
        bestCustomerName = bestCustomerRs.getString("customer_name");
        bestCustomerRevenue = bestCustomerRs.getDouble("total_revenue");
        bestCustomerReservations = bestCustomerRs.getInt("total_reservations");
    }
    
    // finding 5 best transit lines
    String topTransitLinesQuery = "SELECT t.line_name AS transit_line, " +
    "COUNT(r.reservation_id) AS total_reservations, " +
    "SUM(r.fare) AS total_revenue " +
    "FROM reservation r " +
    "JOIN stops origin ON origin.stop_id = r.origin_stop_id " +
    "JOIN train t ON t.train_id = origin.train_id " +
    "GROUP BY t.line_name " +
    "ORDER BY total_reservations DESC " +
    "LIMIT 5";
    
    PreparedStatement topTransitLinesPs = con.prepareStatement(topTransitLinesQuery);
    ResultSet topTransitLinesRs = topTransitLinesPs.executeQuery();
    
    ArrayList<String[]> topTransitLines = new ArrayList<>();
    
    while (topTransitLinesRs.next()) {
        topTransitLines.add(new String[]{
            topTransitLinesRs.getString("transit_line"),
            String.valueOf(topTransitLinesRs.getInt("total_reservations")),
            String.valueOf(topTransitLinesRs.getDouble("total_revenue"))
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
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
	<form action="home.jsp">
		<button type="submit">Back</button>
	</form>
	<div>
		<h2>Sales Report: </h2>
		<table>
			<thead>
				<tr>
					<th>Month-Year</th>
					<th>Revenue</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(int i = 0 ; i < salesMonths.size(); i++){
						String salesMonth = salesMonths.get(i);
						double sales = totalSales.get(i);
				%>
				<tr>
					<td><%=salesMonth %></td>
					<td><%=sales %></td>
				</tr>
				<% } %>
				
			</tbody>
		</table>
	</div>
<!-- 	<form method="GET" action="sales.jsp"> -->
<!--         <label for="transitLine">Transit Line: </label> -->
<!--         <select name="transitLine"> -->
<!--             <option value="">All</option> -->
<%--             <% for (String transitLine : transitLines) { %> --%>
<%--                 <option value="<%=transitLine%>" <%= (transitLine.equals(selectedTransitLine) ? "selected" : "") %>><%= transitLine %></option> --%>
<%--             <% } %> --%>
<!--         </select> -->
<!--         <button type="submit">Filter</button> -->
<!--     </form> -->
<!-- 	<form method="GET" action="sales.jsp"> -->
<!-- 		<label for="customerName">Customer Name: </label> -->
<%-- 		<input type="text" name="customerName" value="<%= (customerName != null ? customerName : "") %>"> --%>
<!-- 		<button type="submit">Filter</button> -->
<!-- 	</form>	 -->
	
	<h2>Customer Revenue</h2>
    <table>
        <thead>
            <tr>
                <th>Customer Name</th>
                <th>Total Revenue ($)</th>
            </tr>
        </thead>
        <tbody>
            <% for (String[] customerData : customerRevenueData) { %>
                <tr>
                    <td><%= customerData[0] %></td>
                    <td>$<%= String.format("%.2f", Double.parseDouble(customerData[1])) %></td>
                </tr>
            <% } %>
        </tbody>
    </table>
    
    <h2>Transit Line Revenue</h2>
    <table>
        <thead>
            <tr>
                <th>Transit Line</th>
                <th>Total Revenue ($)</th>
            </tr>
        </thead>
        <tbody>
            <% for (String[] transitLineData : transitLineRevenueData) { %>
                <tr>
                    <td><%= transitLineData[0] %></td>
                    <td>$<%= String.format("%.2f", Double.parseDouble(transitLineData[1])) %></td>
                </tr>
            <% } %>
        </tbody>
    </table>
    
    <h2>Highlight Customer</h2>
    <table>
    	<thead>
    		<tr>
    			<th>Customer Name</th>
    			<th>Revenue</th>
    			<th>Reservations</th>
    		</tr>
    	</thead>
    	<tbody>
    		<tr>
    			<td><%=bestCustomerName %></td>
    			<td><%=bestCustomerRevenue %></td>
    			<td><%=bestCustomerReservations %></td>
    		</tr>
    	</tbody>
    </table>
    
    <h2>5 Best Transits</h2>
    <table>
    	<thead>
    		<tr>
	    		<th>Transit Names</th>
	    		<th>Revenue</th>
	    		<th>Reservations</th>
    		</tr>
    	</thead>
    	<tbody>
    		<% for (String[] transitLine : topTransitLines) { %>
                <tr>
                    <td><%= transitLine[0] %></td>
                    <td><%= transitLine[1] %></td>
                    <td>$<%= String.format("%.2f", Double.parseDouble(transitLine[2])) %></td>
                </tr>
                <% } %>
    	</tbody>
    </table>
	
</body>