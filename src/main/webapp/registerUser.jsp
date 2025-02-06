<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.train.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%
    // Retrieve form data
    String userName = request.getParameter("userName");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");

    // Perform validation
    if (userName == null || userName.trim().isEmpty() || 
        email == null || email.trim().isEmpty() || 
        password == null || password.trim().isEmpty() || 
        confirmPassword == null || confirmPassword.trim().isEmpty() || 
        firstName == null || firstName.trim().isEmpty() || 
        lastName == null || lastName.trim().isEmpty()) {
        response.sendRedirect("register.jsp?error=missingFields");
        return;
    }

    if (!password.equals(confirmPassword)) {
        response.sendRedirect("register.jsp?error=passwordMismatch");
        return;
    }

    ApplicationDB db = new ApplicationDB();
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        conn = db.getConnection();

        // Check if username already exists
        String checkUser = "SELECT * FROM users WHERE username = ?";
        pstmt = conn.prepareStatement(checkUser);
        pstmt.setString(1, userName);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            response.sendRedirect("register.jsp?error=userExists");
            return;
        }
        rs.close();

        // Hash the password (replace with actual hashing logic)
        String hashedPassword = password; // TODO: Replace with a secure hash like BCrypt.hashpw(password, salt);

        // Insert new user
        String insertUser = "INSERT INTO users (username, password, email, first_name, last_name) VALUES (?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(insertUser);
        pstmt.setString(1, userName);
        pstmt.setString(2, hashedPassword);
        pstmt.setString(3, email);
        pstmt.setString(4, firstName);
        pstmt.setString(5, lastName);

        int result = pstmt.executeUpdate();

        if (result > 0) {
            response.sendRedirect("index.jsp?registration=success");
        } else {
            response.sendRedirect("register.jsp?error=registrationFailed");
        }

    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("register.jsp?error=databaseError");
    } finally {
        // Properly close resources
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
