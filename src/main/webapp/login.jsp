<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.train.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.net.URLEncoder" %>

<%
    // Validate input
    String userName = request.getParameter("userName");
    String password = request.getParameter("password");

    // Check for null or empty inputs
    if (userName == null || userName.trim().isEmpty() || 
        password == null || password.trim().isEmpty()) {
        response.sendRedirect("index.jsp?error=" + URLEncoder.encode("Username and password are required.", "UTF-8"));

    }

    try {
        ApplicationDB db = new ApplicationDB();	
        Connection con = db.getConnection();		

        // Get the key, value pair for the post request
        String query = "SELECT * FROM Users WHERE username = ? AND password = ?";
        PreparedStatement statement = con.prepareStatement(query);
        statement.setString(1, userName);
        statement.setString(2, password);
        ResultSet resultSet = statement.executeQuery();

        if (resultSet.next()) {
			String role = resultSet.getString("role"); // Retrieve the role attribute
			session.setAttribute("user", userName);
			session.setAttribute("role", role);
            session.setAttribute("user_id", resultSet.getInt("user_id"));
            response.sendRedirect("home.jsp?userName=" + URLEncoder.encode(userName, "UTF-8"));
        } else {
            response.sendRedirect("index.jsp?error=" + URLEncoder.encode("Invalid username or password.", "UTF-8"));
        }

    } catch (Exception e) {
        e.printStackTrace(); // This will print the full error details to the server logs
        response.sendRedirect("index.jsp?error=" + URLEncoder.encode("An error occurred: " + e.getMessage(), "UTF-8"));
    }
%>
