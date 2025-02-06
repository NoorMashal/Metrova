<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*, com.train.pkg.*" %>
<%
    // Ensure user has the representative role
    String userRole = (String) session.getAttribute("role");
    if (!"representative".equals(userRole)) {
        response.sendRedirect("accessDenied.jsp");
        return;
    }

    // Fetch customer queries and replies from the database
    ApplicationDB db = new ApplicationDB();
    Connection conn = null;
    PreparedStatement queryStmt = null;
    PreparedStatement replyStmt = null;
    ResultSet queryRs = null;
    ResultSet replyRs = null;

    String error = null;

    try {
        conn = db.getConnection();

        // Fetch all queries with their status and customer ID
        String querySql = "SELECT q.query_id, q.customer_id, u.first_name, u.last_name, q.query_text, q.query_date, q.status " +
                          "FROM queries q " +
                          "JOIN Users u ON q.customer_id = u.user_id " +
                          "ORDER BY q.query_date ASC";
        queryStmt = conn.prepareStatement(querySql);
        queryRs = queryStmt.executeQuery();
    } catch (SQLException e) {
        e.printStackTrace();
        error = "An error occurred while fetching queries.";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Forum - Customer Queries</title>
    <link rel="stylesheet" href="./styles/reply.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="forum-container">
        <h1>Customer Query Forum</h1>
        <% if (error != null) { %>
            <p class="error"><%= error %></p>
        <% } %>

        <% if (queryRs != null) { %>
            <% 
                while (queryRs.next()) {
                    int queryId = queryRs.getInt("query_id");
                    int customerId = queryRs.getInt("customer_id");
                    String customerName = queryRs.getString("first_name") + " " + queryRs.getString("last_name");
                    String queryText = queryRs.getString("query_text");
                    Timestamp queryDate = queryRs.getTimestamp("query_date");
                    String status = queryRs.getString("status");
            %>
            <div class="post">
                <h3>Query from <%= customerName %> (Customer ID: <%= customerId %>) - <%= queryDate %></h3>
                <p><strong>Question:</strong> <%= queryText %></p>
                <p><strong>Status:</strong> <%= status.equals("solved") ? "Solved" : "Open" %></p>

                <!-- Fetch and display replies -->
                <div class="replies">
                    <h4>Replies:</h4>
                    <%
                        try {
                            String replySql = "SELECT r.reply_text, r.reply_date, " +
                                              "CASE " +
                                              "    WHEN r.representative_id IS NOT NULL THEN CONCAT(rep.first_name, ' ', rep.last_name) " +
                                              "    WHEN r.customer_id IS NOT NULL THEN 'Customer' " +
                                              "    ELSE 'Unknown' " +
                                              "END AS reply_by " +
                                              "FROM replies r " +
                                              "LEFT JOIN Users rep ON r.representative_id = rep.user_id " +
                                              "WHERE r.query_id = ? " +
                                              "ORDER BY r.reply_date ASC";
                            replyStmt = conn.prepareStatement(replySql);
                            replyStmt.setInt(1, queryId);
                            replyRs = replyStmt.executeQuery();

                            if (!replyRs.isBeforeFirst()) {
                                out.println("<p>No replies yet.</p>");
                            } else {
                                while (replyRs.next()) {
                                    String replyText = replyRs.getString("reply_text");
                                    String replyBy = replyRs.getString("reply_by");
                                    Timestamp replyDate = replyRs.getTimestamp("reply_date");
                    %>
                    <div class="reply">
                        <p><strong><%= replyBy %>:</strong> <%= replyText %></p>
                        <p><em>Posted on: <%= replyDate %></em></p>
                    </div>
                    <% 
                                } 
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                            out.println("<p>Error loading replies.</p>");
                        } finally {
                            if (replyRs != null) replyRs.close();
                        }
                    %>
                </div>

                <!-- Reply Form -->
                <% if (!status.equals("solved")) { %>
                <div class="reply-form">
                    <form action="submitReply.jsp" method="POST">
                        <input type="hidden" name="queryId" value="<%= queryId %>">
                        <textarea name="replyText" placeholder="Type your reply here..." required></textarea>
                        <input type="hidden" name="userRole" value="representative">
                        <button type="submit">Submit Reply</button>
                    </form>
                </div>
                <% } %>

                <!-- Actions -->
                <div class="actions">
                    <% if (!status.equals("solved")) { %>
                    <form action="markAsSolved.jsp" method="POST">
                        <input type="hidden" name="queryId" value="<%= queryId %>">
                        <button type="submit">Mark as Solved</button>
                    </form>
                    <% } %>
                    <form action="deleteQuery.jsp" method="POST">
                        <input type="hidden" name="queryId" value="<%= queryId %>">
                        <button type="submit" onclick="return confirm('Are you sure you want to delete this query?')">Delete Query</button>
                    </form>
                </div>
            </div>
            <% 
                } 
            %>
        <% } else { %>
        <p>No queries to display.</p>
        <% } %>
    </div>
</body>
</html>

<%
    // Close database resources
    try {
        if (queryRs != null) queryRs.close();
        if (queryStmt != null) queryStmt.close();
        if (replyStmt != null) replyStmt.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
