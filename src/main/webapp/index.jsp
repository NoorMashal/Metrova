<%@ page language="java" contentType="text/html; charset=ISO-8859-1" 
    pageEncoding="ISO-8859-1" import="com.train.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>TrainBooking Login</title>
  <link rel="stylesheet" href="./styles/index.css">
  <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
</head>
<body>
  <div class="wrapper">
    <form method="post" action="login.jsp">
      <h1>Login</h1>
      <div class="input-box">
        <input type="text" id="userName" name="userName" placeholder="Username" required>
        <i class='bx bxs-user'></i>
      </div>
      <div class="input-box">
        <input type="password" id="password" name="password" placeholder="Password" required>
        <i class='bx bxs-lock-alt' ></i>
      </div>
      <button type="submit" class="btn">Login</button>
      <div class="register-link">
        <p>Don't have an account? <a href="register.jsp">Register</a></p>
      </div>
    </form>
  </div>
  <div class="footer">Train Booking</div>
</body>
</html>
