<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.train.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.net.URLEncoder" %>

<%
    ArrayList<String> stations = new ArrayList<>();
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
    String today = sdf.format(new java.util.Date());

    try {
        ApplicationDB db = new ApplicationDB();	
        Connection con = db.getConnection();		

        // Get the key, value pair for the post request
        String query = "select s.station_name from stations s";
        Statement statement = con.createStatement();
        ResultSet resultSet = statement.executeQuery(query);

        while (resultSet.next()) {
            stations.add(resultSet.getString("station_name"));
        }
    } catch (Exception e) {
        e.printStackTrace(); // This will print the full error details to the server logs
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="./styles/home.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="main">
        <form id="route" action="findPath.jsp" method="POST">
            <!-- ComboBox 1 -->
            <label for="origin">Origin Station:</label>
            <select name="origin" id="origin" required>
                <option value="">--Please choose an option--</option>
                <% for (String station : stations) { %>
                <option value="<%= station %>"><%= station %></option>
            <% } %>
            </select>
            <!-- ComboBox 2 -->
            <label for="destination">Destination Station</label>
            <select name="destination" id="destination" required>
                <option value="">--Please choose an option--</option>
                <% for (String station : stations) { %>
                <option value="<%= station %>"><%= station %></option>
            <% } %>>
            </select>

             <!-- Date Selector -->
            <label for="travelDate">Travel Date:</label>
            <input type="date" id="travelDate" name="travelDate" required min="<%= today %>">
            <button type="submit">Submit</button>
        </form>
    </div>
</body>
</html>