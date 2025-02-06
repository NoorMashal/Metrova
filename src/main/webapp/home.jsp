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
        <h2>Welcome, <%=session.getAttribute("user")%>!</h2>
        <h2> Role ( <%=session.getAttribute("role")%> )</h2>
    </div>
</body>
</html>