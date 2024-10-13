<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*, javax.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
// Retrieve the image source from the request
String imageSrc = request.getParameter("imageSrc");
double price = Double.parseDouble(request.getParameter("price")); // Assuming price is passed as a parameter
System.out.println(imageSrc);
// JDBC Connection
Connection conn = null;
PreparedStatement pstmt = null;

try {
    // Establish database connection (adjust this based on your database setup)
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://SRI\\SQLExpress;databaseName=connection;encrypt=false;integratedSecurity=true;portNumber=1433;"); // Replace with your database URL, username, and password

    // SQL statement to insert image into database (adjust table and column names)
    //String sql = "INSERT INTO images (image_src) VALUES (?)";
    //pstmt = conn.prepareStatement(sql);
    //pstmt.setString(1, imageSrc);
    
    
    String sql = "INSERT INTO images3 (image_source, price) VALUES (?, ?)";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, imageSrc);
    pstmt.setDouble(2, price);
    
    // Execute insert query
    int rowsInserted = pstmt.executeUpdate();
    
    if (rowsInserted > 0) {
        // Image inserted successfully
        response.setStatus(200);
    } else {
        // Failed to insert image
        response.setStatus(500); // Server error
    }
} catch (Exception e) {
    // Handle any exceptions
    e.printStackTrace();
    response.setStatus(500); // Server error
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
