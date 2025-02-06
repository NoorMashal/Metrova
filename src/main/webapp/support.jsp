<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*, com.train.pkg.*" %>
<%
    String userRole = (String) session.getAttribute("role");
    int userId = (int) session.getAttribute("user_id");

    if (!"customer".equals(userRole) && !"representative".equals(userRole)) {
        response.sendRedirect("accessDenied.jsp");
        return;
    }

    ApplicationDB db = new ApplicationDB();
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    String error = null;

    String searchKeyword = request.getParameter("searchKeyword");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Support Page</title>
    <link rel="stylesheet" href="./styles/support.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="support-container">
        <h1>Support</h1>
        <% if (error != null) { %>
            <p class="error"><%= error %></p>
        <% } %>

        <!-- Search Form -->
        <h2>Search Questions</h2>
        <form method="GET" action="support.jsp">
            <input type="text" name="searchKeyword" placeholder="Search by keyword" value="<%= searchKeyword != null ? searchKeyword : "" %>" required>
            <button type="submit">Search</button>
        </form>

        <!-- Ask a Question (Customer Only) -->
        <% if ("customer".equals(userRole)) { %>
        <h2>Ask a Question</h2>
        <form action="submitQuery.jsp" method="POST">
            <textarea name="queryText" placeholder="Type your question here..." required></textarea>
            <button type="submit">Submit</button>
        </form>
        <% } %>

        <!-- Browse Questions -->
        <h2>All Questions</h2>
        <%
            try {
                conn = db.getConnection();
                String query = "SELECT q.query_id, q.query_text, q.query_date, q.status, u.first_name, u.last_name " +
                               "FROM queries q " +
                               "JOIN users u ON q.customer_id = u.user_id ";
                if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                    query += "WHERE q.query_text LIKE ? ";
                }
                query += "ORDER BY q.query_date ASC";

                stmt = conn.prepareStatement(query);
                if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                    stmt.setString(1, "%" + searchKeyword + "%");
                }
                rs = stmt.executeQuery();

                if (!rs.isBeforeFirst()) {
                    out.println("<p>No questions found.</p>");
                } else {
                    while (rs.next()) {
                        int queryId = rs.getInt("query_id");
                        String queryText = rs.getString("query_text");
                        String queryDate = rs.getString("query_date");
                        String status = rs.getString("status");
                        String customerName = rs.getString("first_name") + " " + rs.getString("last_name");

                        out.println("<div class='question'>");
                        out.println("<p><strong>Question:</strong> " + queryText + "</p>");
                        out.println("<p><strong>Customer:</strong> " + customerName + "</p>");
                        out.println("<p><em>Posted on: " + queryDate + "</em></p>");
                        out.println("<p><strong>Status:</strong> " + (status.equals("solved") ? "Solved" : "Open") + "</p>");

                        // Fetch Replies
                        PreparedStatement replyStmt = conn.prepareStatement(
                            "SELECT r.reply_text, r.reply_date, " +
                            "CASE WHEN r.customer_id IS NOT NULL THEN CONCAT(c.first_name, ' ', c.last_name) " +
                            "WHEN r.representative_id IS NOT NULL THEN CONCAT(rep.first_name, ' ', rep.last_name) " +
                            "ELSE 'Unknown' END AS reply_by " +
                            "FROM replies r " +
                            "LEFT JOIN users c ON r.customer_id = c.user_id " +
                            "LEFT JOIN users rep ON r.representative_id = rep.user_id " +
                            "WHERE r.query_id = ? " +
                            "ORDER BY r.reply_date ASC");
                        replyStmt.setInt(1, queryId);
                        ResultSet replyRs = replyStmt.executeQuery();
                        out.println("<div class='replies'><h4>Replies:</h4>");
                        if (!replyRs.isBeforeFirst()) {
                            out.println("<p>No replies yet.</p>");
                        } else {
                            while (replyRs.next()) {
                                String replyBy = replyRs.getString("reply_by");
                                String replyText = replyRs.getString("reply_text");
                                String replyDate = replyRs.getString("reply_date");

                                out.println("<p><strong>" + replyBy + ":</strong> " + replyText + " <em>(" + replyDate + ")</em></p>");
                            }
                        }
                        out.println("</div>");
                        replyRs.close();
                        replyStmt.close();

                        // Representative Reply Form
                        if ("representative".equals(userRole)) {
                            out.println("<div class='reply-form'>");
                            out.println("<h4>Reply to Question</h4>");
                            out.println("<form action='submitReply.jsp' method='POST'>");
                            out.println("<input type='hidden' name='queryId' value='" + queryId + "'>");
                            out.println("<textarea name='replyText' placeholder='Type your reply here...' required></textarea>");
                            out.println("<button type='submit'>Reply</button>");
                            out.println("</form>");
                            out.println("</div>");
                        }

                     	// Mark as Solved and Delete Options
                        if ("representative".equals(userRole)) {
                            out.println("<div class='rep-actions'>");
                            // Toggle between Mark as Solved and Mark as Unsolved
                            out.println("<form action='toggleQueryStatus.jsp' method='POST'>");
                            out.println("<input type='hidden' name='queryId' value='" + queryId + "'>");
                            if (!status.equals("solved")) {
                                out.println("<button type='submit'>Mark as Solved</button>");
                            } else {
                                out.println("<button type='submit'>Mark as Unsolved</button>");
                            }
                            out.println("</form>");
                            
                            // Delete the question
                            out.println("<form action='deleteQuery.jsp' method='POST'>");
                            out.println("<input type='hidden' name='queryId' value='" + queryId + "'>");
                            out.println("<button type='submit' onclick='return confirm(\"Are you sure you want to delete this question?\")'>Delete</button>");
                            out.println("</form>");
                            out.println("</div>");
                        }

                        // Customer Reply Form (if Open)
                        if ("customer".equals(userRole) && status.equals("open")) {
                            out.println("<div class='reply-form'>");
                            out.println("<h4>Your Reply</h4>");
                            out.println("<form action='submitReply.jsp' method='POST'>");
                            out.println("<input type='hidden' name='queryId' value='" + queryId + "'>");
                            out.println("<textarea name='replyText' placeholder='Type your reply here...' required></textarea>");
                            out.println("<button type='submit'>Reply</button>");
                            out.println("</form>");
                            out.println("</div>");
                        }

                        out.println("</div>");
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p>Error loading questions.</p>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>
    </div>
</body>
</html>
