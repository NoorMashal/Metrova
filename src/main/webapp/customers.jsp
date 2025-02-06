<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.train.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.net.URLEncoder" %>

<%
	
	// retrieve all customers from DB, and add a search input that looks up customers
	ArrayList<String[]> customers = new ArrayList<>();

	try {
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		// query users to retrieve all customers
		String query = "SELECT u.username, u.first_name, u.last_name, u.role " + 
		"FROM Users u WHERE u.role = 'customer' OR u.role = 'representative' GROUP BY u.first_name, u.last_name, u.username, u.role ORDER BY u.first_name";
		Statement statement = con.prepareStatement(query);
		ResultSet resultSet = statement.executeQuery(query);
		
		while(resultSet.next()){
			String[] customer = new String[4];
			customer[0] = resultSet.getString("username");
			customer[1] = resultSet.getString("first_name");
			customer[2] = resultSet.getString("last_name");
			customer[3] = resultSet.getString("role");
			
			customers.add(customer);
		}
		
	} catch(Exception e) {
		e.printStackTrace();
	}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="./styles/customer_lookup.css">
</head>
<body>
	<form action="home.jsp" style="margin: 4px; z-index: 2;">
				<button type="submit">Back</button>
	</form>
	<div class="customer-lookup">
		<div style="display: flex; justify-Content: space-between; width: 80%;">
			Available Customers:
			<form action="addCustomer.jsp" method="GET">
				<button type="submit">Add</button>
			</form>
		</div>
		<!-- List out all customers and have a search input to narrow down customers -->
		<% 
			for(int i = 0; i < customers.size(); i++){
				String[] customer = customers.get(i);
				
		%>
		<div class="customer-card">
			<div class="customer-detail">First Name: <div><%= customer[1] %></div></div>
			<div class="customer-detail">Last Name: <div><%= customer[2] %></div></div>
			<div class="customer-detail">Username: <div><%= customer[0] %></div></div>
			<div class="customer-detail">Role: <div><%= customer[3] %></div></div>
			<div class="btns">
				<form action="editCustomer.jsp" method="GET">
					<input type="hidden" name="username" value="<%= customer[0] %>">
					<button type="submit">Edit</button>
				</form>
				<form action="deleteCustomer.jsp" method="POST">
					<input type="hidden" name="username" value="<%= customer[0] %>">
					<button type="submit">Delete</button>
				</form>
			</div>
		</div>
		<% } %>
	</div>
</body>