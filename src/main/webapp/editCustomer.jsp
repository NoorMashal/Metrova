<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.train.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.net.URLEncoder" %>

<%
	//retrieve the user to edit for
	ArrayList<String> user = new ArrayList<>();
	String username = request.getParameter("username");

	try {
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		// query users to retrieve all customers and their corresponding details
		String query = "SELECT u.username, u.first_name, u.last_name, u.email, u.password, u.role, u.user_id " + 
		"FROM Users u WHERE " + 
		"u.username = ?";
		PreparedStatement statement = con.prepareStatement(query);
		statement.setString(1, username);
		ResultSet resultSet = statement.executeQuery();
		
		while(resultSet.next()){
			user.add(resultSet.getString("username"));
			user.add(resultSet.getString("first_name"));
			user.add(resultSet.getString("last_name"));
			user.add(resultSet.getString("email"));
			user.add(resultSet.getString("password"));
			user.add(resultSet.getString("role"));
			user.add(resultSet.getString("user_id"));
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
	<div>
		<form action="updateCustomer.jsp" method="POST">
			<div>Username: <input type="text" name="username" value="<%=user.get(0) %>"></div>
			<div>First Name: <input type="text" name="first_name" value="<%=user.get(1) %>"></div>
			<div>Last Name: <input type="text" name="last_name" value="<%=user.get(2) %>"></div>
			<div>Email: <input type="text" name = "email" value="<%=user.get(3) %>"></div>
<!-- 			<select> -->
<%-- 				<option value="<%=user.get(5) %>"><%=user.get(5) %></option> --%>
<!-- 			</select> -->
			<div>Role: <input type="text" name="role" value="<%=user.get(5) %>"></div>
			<div>User ID: <input name="user_id" readonly type="text" value="<%=user.get(6) %>"></div>
			<button type="submit">Submit Changes</button>
		</form>
	</div>
</body>