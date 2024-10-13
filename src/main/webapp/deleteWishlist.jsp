<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Base64" %>

<%
Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    String url = "jdbc:sqlserver://SRI\\SQLExpress;databaseName=connection;encrypt=false;integratedSecurity=true;portNumber=1433;";
   
    conn = DriverManager.getConnection(url);

    // Retrieve image ID from request parameter
    String imageIdStr = request.getParameter("imageId");
    int imageId = Integer.parseInt(imageIdStr);
	System.out.println(imageId);
    // SQL query to delete image from database
    String deleteSql = "DELETE FROM images3 WHERE id = ?";
    pstmt = conn.prepareStatement(deleteSql);
    pstmt.setInt(1, imageId);
    int rowsAffected = pstmt.executeUpdate();

    if (rowsAffected > 0) {
        // Image deleted successfully
%>
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <title>Delete Image</title>
            <script>
                alert("Image deleted successfully.");
                window.location.href = "wishlist.jsp"; // Redirect to display page after deletion
            </script>
        </head>
        <body>
            <h2>Image Deleted</h2>
        </body>
        </html>
<%
    } else {
        // Handle case where image with given ID was not found
        out.println("Image with ID " + imageId + " not found in database.");
    }

} catch (ClassNotFoundException | SQLException e) {
    e.printStackTrace();
    out.println("Error: " + e.getMessage());
} finally {
    try {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>
