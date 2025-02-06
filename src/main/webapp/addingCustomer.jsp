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
		String username = request.getParameter("username");
		String firstName = request.getParameter("first_name");
		String lastName = request.getParameter("last_name");
		String email = request.getParameter("email");
		String role = request.getParameter("role");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");
		
		if(!confirmPassword.equals(password)){
			out.println("<div>Password not the same! Redirecting back to home page...</div>");
			out.println(confirmPassword);
			out.println(password);
			response.setHeader("Refresh", "2;url=home.jsp");
		}
		else if(!email.contains("@")){
			out.println("<div>Invalid Email! Redirecting back to home page...</div>");
			response.setHeader("Refresh", "2;url=home.jsp");
		}
		else{
			
			try{
				ApplicationDB db = new ApplicationDB();
				Connection con = db.getConnection();
				
				String query = "INSERT INTO users (username, password, email, first_name, last_name, role) " + 
				"VALUES(?, ?, ?, ?, ?, ?)";
				PreparedStatement statement = con.prepareStatement(query);
				// TODO: add values
				statement.setString(1, username);
				statement.setString(2, password);
				statement.setString(3, email);
				statement.setString(4, firstName);
				statement.setString(5, lastName);
				statement.setString(6, role);
				
				
				int rowsUpdated = statement.executeUpdate();
				
				if(rowsUpdated > 0){
					out.println("<div>User added successfully! Redirecting back to home page...</div>");
					response.setHeader("Refresh", "2;url=home.jsp");
				}
				else{
					out.println("<div>User did not add successfully... Redirecting back to home page...</div>");
					response.setHeader("Refresh", "2;url=home.jsp");
				}
			} catch(Exception e){
				e.printStackTrace();
				out.println("<div>Error: " + e.getMessage() + "</div>");
				response.setHeader("Refresh", "2;url=home.jsp");
			}
		}
	%>
</body>