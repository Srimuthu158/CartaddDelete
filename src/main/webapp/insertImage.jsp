<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
// Retrieve the image source from the request
String imageSrc = request.getParameter("imageSrc");
String imageIdwish = request.getParameter("imageIdwish");
System.out.println("imageIdwish"+imageIdwish);
double price = Double.parseDouble(request.getParameter("price")); // Assuming price is passed as a parameter
System.out.println(imageSrc);
// JDBC Connection
Connection conn = null;
PreparedStatement pstmt = null;

try {
    // Establish database connection (adjust this based on your database setup)
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    conn = DriverManager.getConnection("jdbc:sqlserver://SRI\\SQLExpress;databaseName=connection;encrypt=false;integratedSecurity=true;portNumber=1433;"); // Replace with your database URL, username, and password

    // SQL statement to check if the product already exists
    String checkSql = "SELECT id, quantity FROM images2 WHERE image_source = ?";
    PreparedStatement checkStmt = conn.prepareStatement(checkSql);
    checkStmt.setString(1, imageSrc);
    ResultSet rs = checkStmt.executeQuery();

    if (rs.next()) {
        // Product already exists, update quantity
        int existingQuantity = rs.getInt("quantity");
        String updateSql = "UPDATE images2 SET quantity = ? WHERE image_source = ?";
        PreparedStatement updateStmt = conn.prepareStatement(updateSql);
        updateStmt.setInt(1, existingQuantity + 1); // Increment quantity
        updateStmt.setString(2, imageSrc);
        updateStmt.executeUpdate();
        
     
    } else {
        // Product doesn't exist, insert new record
        String insertSql = "INSERT INTO images2 (image_source, price, quantity) VALUES (?, ?, 1)";
        pstmt = conn.prepareStatement(insertSql);
        pstmt.setString(1, imageSrc);
        pstmt.setDouble(2, price);
        pstmt.executeUpdate();
       
    }
    if(imageIdwish!=null ||imageIdwish!=""){
    	// After inserting into cart, delete the item from the wishlist
        String deleteSql = "DELETE FROM images3 WHERE id = ?";
        pstmt = conn.prepareStatement(deleteSql);
        pstmt.setString(1, imageIdwish);
        pstmt.executeUpdate();

        // Redirect back to wishlist.jsp after successful operations
        response.sendRedirect("wishlist.jsp");
    }

    // Send response
    response.setStatus(200);
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
