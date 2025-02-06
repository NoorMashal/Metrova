<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.train.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submitting Edit</title>
    <link rel="stylesheet" href="./styles/customer_lookup.css">
</head>

<body>
	<%
		try {
			ApplicationDB db = new ApplicationDB();	
	        Connection con = db.getConnection();
			
			// update the database with the new info
			String username = request.getParameter("username");
			String firstName = request.getParameter("first_name");
			String lastName = request.getParameter("last_name");
			String email = request.getParameter("email");
			String role = request.getParameter("role");
			String userID = request.getParameter("user_id");
			
			if (username == null || username.trim().isEmpty() || email == null || !email.contains("@")) {
	            out.println("<div>Invalid input. Redirecting back...</div>");
	            response.setHeader("Refresh", "2;url=editCustomer.jsp");
	            return;
	        }
			
			String query = "UPDATE users SET username = ?, first_name = ?, last_name = ?, email = ?, role = ? " + 
			"WHERE user_id = ? AND NOT EXISTS (" + 
			"SELECT * FROM (SELECT username, email, user_id FROM users) AS temp_users WHERE (temp_users.username = ? OR temp_users.email = ?) AND temp_users.user_id != ?);";
			
			PreparedStatement statement = con.prepareStatement(query);
			statement.setString(1, username);
			statement.setString(2, firstName);
			statement.setString(3, lastName);
			statement.setString(4, email);
			statement.setString(5, role);
			statement.setString(6, userID);
			statement.setString(7, username);
			statement.setString(8, email);
			statement.setString(9, userID);
			
			int rowsUpdated = statement.executeUpdate();
			
			if(rowsUpdated > 0){
				out.println("<div>User changed successfully! Redirecting back to home page...</div>");
				response.setHeader("Refresh", "2;url=home.jsp");
			}
			else{
				out.println("<div>User did not change successfully :( Redirecting back to home page...</div>");
				out.println("<div>Debug Info:</div>");
				out.println("<div>Username: " + username + "</div>");
				out.println("<div>First Name: " + firstName + "</div>");
				out.println("<div>Last Name: " + lastName + "</div>");
				out.println("<div>Email: " + email + "</div>");
				out.println("<div>Role: " + role + "</div>");
				out.println("<div>UserID: " + userID + "</div>");

				response.setHeader("Refresh", "5;url=home.jsp");
			}
			
		} catch(Exception e) {
			e.printStackTrace();
			out.println("<div>ERROR: " + e.getMessage() + "</div>");
			response.setHeader("Refresh", "2;url=home.jsp");
		}
	%>
</body>