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
		try{
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
			
			String username = request.getParameter("username");
			
			String query = "DELETE FROM users WHERE users.username = ?";
			PreparedStatement statement = con.prepareStatement(query);
			statement.setString(1, username);
			
			int rowsUpdated = statement.executeUpdate();
			
			if(rowsUpdated > 0){
				out.println("<div>User deleted successfully! Redirecting back to home page...</div>");
				response.setHeader("Refresh", "2;url=home.jsp");
			}
			else{
				out.println("<div>User did not delete successfully... Redirecting back to home page...</div>");
				response.setHeader("Refresh", "2;url=home.jsp");
			}
		} catch(Exception e){
			e.printStackTrace();
			out.println("<div>Error: " + e.getMessage() + "</div>");
		}
	%>
</body>