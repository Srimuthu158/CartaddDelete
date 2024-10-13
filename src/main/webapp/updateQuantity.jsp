<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %>

<%
String imageSrc = request.getParameter("imageSrc");

if (imageSrc != null) {
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://SRI\\SQLExpress;encrypt=false;databaseName=connection;integratedSecurity=true;portNumber=1433;";
       
        conn = DriverManager.getConnection(url);
	
        
        
        // Update quantity logic
        String updateSql = "UPDATE images2 SET quantity = quantity - 1 WHERE image_source = ?";
        pstmt = conn.prepareStatement(updateSql);
        pstmt.setString(1, imageSrc);
        pstmt.executeUpdate();

        response.sendRedirect("cart.jsp");
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
        response.setStatus(500); // Server error
    } finally {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
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
} else {
    response.setStatus(400); // Bad request
}
%>
