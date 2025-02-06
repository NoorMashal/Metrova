<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.train.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Logging Out</title>
    <link rel="stylesheet" type="text/css" href="success.css">
</head>
<body>
    <div class="main">
        <div class="welcome-container">
            <%
            try {
                // Get the username before invalidating session for message
                String userName = (String)session.getAttribute("user");
                
                // Invalidate the session
                session.invalidate();
                
                try {
                    session.getAttribute("user");
                } catch(Exception e) {
                    out.println("<div class='success-message'>Goodbye, " + userName + "! You have been logged out.</div>");
                    out.println("<div class='success-message'>Will redirect you back to login page...</div>");
                }
                
                // Add a small delay before redirect (2 seconds)
                response.setHeader("Refresh", "2;url=index.jsp");
                
            } catch (Exception e) {
                out.print(e);
            }
            %>
        </div>
    </div>
</body>
</html>