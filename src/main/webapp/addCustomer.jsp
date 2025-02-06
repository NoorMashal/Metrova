<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.train.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.net.URLEncoder" %>

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
		<form action="addingCustomer.jsp" method="POST">
			<div>Username: <input type="text" name="username" required></div>
			<div>Password: <input type="password" name="password" required></div>
			<div>Confirm Password: <input type="password" name="confirmPassword" required></div>
			<div>First Name: <input type="text" name="first_name" required></div>
			<div>Last Name: <input type="text" name="last_name" required></div>
			<div>Email: <input type="text" name = "email" required></div>
<!-- 			<select> -->
<%-- 				<option value="<%=user.get(5) %>"><%=user.get(5) %></option> --%>
<!-- 			</select> -->
			<select name="role" id="destination" required>
                <option value="">--Please choose an option--</option>
                
                <option value="customer">Customer</option>
                <option value="representative">Representative</option>
            </select>
			<button type="submit">Submit Changes</button>
		</form>
	</div>
</body>