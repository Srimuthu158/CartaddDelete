<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.net.URLEncoder" %>

<%
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // Establish database connection (adjust URL, username, and password)
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://SRI\\SQLExpress;databaseName=connection;encrypt=false;integratedSecurity=true;portNumber=1433;";// Replace with your database URL
        
        conn = DriverManager.getConnection(url);

        // Get imageSrc parameter from request
        String imageUrl = request.getParameter("imageSrc");

        // SQL statement to delete the item from cart based on imageSrc
        String sql = "DELETE FROM images2 WHERE imageSrc = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, imageUrl);
        int rowsDeleted = pstmt.executeUpdate();

        // Check if deletion was successful
        if (rowsDeleted > 0) {
            out.println("Item deleted successfully from cart.");
        } else {
            out.println("Failed to delete item from cart.");
        }
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
        out.println("Error deleting item from cart: " + e.getMessage());
    } finally {
        // Close resources
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
