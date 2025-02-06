<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.train.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Success Page!</title>
    <link rel="stylesheet" type="text/css" href="./styles/success.css">
</head>
<body>
    <div class="main">
        <div class="welcome-container">
            <%
            try {
                String userName = request.getParameter("userName");
                session.setAttribute("user", userName);
                
                if (session.getAttribute("user") != null) {
                    %>
                    <h2>Welcome, <%=session.getAttribute("user")%>!</h2>
                    <div class="success-message">You have successfully logged in</div>
                    
                    <%
                } else {
                    %>
                    <div class="success-message">You are not logged in!</div>
                    <form action="index.jsp" method="GET">
                        <input type="submit" value="Back to Login" class="logout-button"/>
                    </form>
                    <%
                }
            } catch (Exception e) {
                out.print(e);
            }
            %>
        </div>
    </div>
</body>
</html>
